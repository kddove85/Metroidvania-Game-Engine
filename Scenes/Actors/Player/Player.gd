extends "res://Scenes/Actors/Actor.gd"

enum STATES {DEFAULT, MORPHED}

onready var current_state = STATES.DEFAULT

onready var camera = $Camera2D
onready var staff = $Staff
onready var timer = $Timer
onready var projectile_spawn_point = $AnimatedSprite/ProjectileSpawnPoint

var is_able_to_unmorph = true

const ETANK = "etank"
const ETANK_VALUE = 100

signal player_ready()
signal game_over()

func _ready():
	var hud = load("res://Scenes/UI/HUD.tscn").instance()
	add_child(hud)
	player_update_hud()

func _physics_process(delta):
	blink()
	motion.y += gravity * delta
	var direction = get_direction()
	if direction.x > 0:
		sprite.scale.x = 1
		staff.flip_h = false
	if direction.x < 0:
		sprite.scale.x = -1
		staff.flip_h = true
	
	var is_jump_interrupted = Input.is_action_just_released("ui_accept") and motion.y < 0.0
	motion = calculate_move_velocity(motion, direction, speed, is_jump_interrupted)
	motion = move_and_slide(motion, Vector2.UP)
	
func get_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("ui_accept") else 0
	)
	
func calculate_move_velocity(linear_velocity, direction, pace, is_jump_interrupted):
	var velocity = linear_velocity
	velocity.x = pace.x * direction.x
	if direction.y != 0.0:
		velocity.y = pace.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity
	
func _input(_event):
#	var joypads = Input.get_connected_joypads()
#	for joypad in joypads:
#		print(Input.get_joy_name(joypad))
	if Input.is_action_just_pressed("ui_fire"):
		var projectile = load("res://Scenes/Projectiles/PlayerProjectileA.tscn").instance()
		projectile.global_position = projectile_spawn_point.global_position
		projectile.set_as_toplevel(true)
		projectile.direction = sprite.scale.x
		add_child(projectile)
		staff.play("Fire")
		
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("save")
		
	if Input.is_action_just_pressed("ui_down") and current_state == STATES.DEFAULT:
		sprite.play("Morphed")
		current_state = STATES.MORPHED
		self.get_node("DefaultShape").disabled = true
		self.get_node("Hurtboxes/HurtBox/CollisionShape2D").disabled = true
		
	if Input.is_action_just_pressed("ui_up") and current_state == STATES.MORPHED and is_able_to_unmorph:
		sprite.play("default")
		current_state = STATES.DEFAULT
		self.get_node("DefaultShape").disabled = false
		self.get_node("Hurtboxes/HurtBox/CollisionShape2D").disabled = false
		
func item_collected(type):
	if type == ETANK:
		stats.max_hp = stats.max_hp + ETANK_VALUE
		stats.current_hp = stats.max_hp
		player_update_hud()
		
func player_update_hud():
	get_node("HUD").update_hud(self)

func _on_RoomDetector_area_entered(area):
	print("Room Detected")
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2

	camera.limit_top = collision_shape.global_position.y - size.y*area.scale.y/2
	camera.limit_left = collision_shape.global_position.x - size.x*area.scale.x/2
	camera.limit_bottom = camera.limit_top + size.y * area.scale.y
	camera.limit_right = camera.limit_left + size.x * area.scale.x

func _on_Staff_animation_finished():
	if staff.animation == "Fire":
		staff.play("default")

func _on_UnmorphDetector_body_entered(_body):
	is_able_to_unmorph = false
	print("Can't Unmorph")

func _on_UnmorphDetector_body_exited(_body):
	is_able_to_unmorph = true
	print("Can unmorph")

func on_damage(damage):
	stats.current_hp = stats.current_hp - damage
	player_update_hud()
	if stats.current_hp <= 0:
		print("Game Over")
		# play death animation
		emit_signal("game_over")
		get_tree().paused = true

func _on_Timer_timeout():
	emit_signal("player_ready")
