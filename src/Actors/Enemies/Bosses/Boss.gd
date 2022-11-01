extends "res://src/Actors/Enemies/Enemy.gd"

enum STATES {IDLE, DIVE_ATTACK, THRUST_ATTACK, PROJECTILE_ATTACK}

onready var attack_timer = $Timer
onready var projectile_spawn_point = $AnimatedSprite/ProjectileSpawnPoint

var boss_health_bar = load("res://src/UI/BossHealthBar.tscn").instance()
var attacks = [STATES.DIVE_ATTACK, STATES.THRUST_ATTACK, STATES.PROJECTILE_ATTACK]
var positions = [Vector2(8232, 2343), Vector2(9175, 2343)]

signal boss_defeated()

func _ready():
	current_state = STATES.IDLE
	add_child(boss_health_bar)
	boss_health_bar.health_bar.max_value = stats.max_hp
	boss_health_bar.health_bar.value = stats.current_hp
	boss_health_bar.boss_name.text = "Henry"
	motion.x = speed.x

func _physics_process(delta):
	blink()
	match current_state:
		STATES.DIVE_ATTACK:
			$Label.text = "Dive Attack"
			dive(delta)
		STATES.THRUST_ATTACK:
			$Label.text = "Thrust Attack"
			motion.y += gravity * delta
			motion = move_and_slide(motion, Vector2.UP)
			thrust(delta)
		STATES.PROJECTILE_ATTACK:
			$Label.text = "Projectile Attack"
			motion.y += gravity * delta
			motion = move_and_slide(motion, Vector2.UP)
			shoot_projectile()
		STATES.IDLE:
			$Label.text = "Idle"
			motion = Vector2(0, 0)
			
func dive(delta):
	motion.y += gravity * TILE_SIZE * delta
	motion = move_and_slide(motion, Vector2.UP)
	if is_on_floor():
		current_state = STATES.IDLE
		
func thrust(delta):
	motion.x += WALK_SPEED * TILE_SIZE * delta * direction
	motion = move_and_slide(motion, Vector2.UP)
	if is_on_wall():
		current_state = STATES.IDLE
		direction = 0
		
func shoot_projectile():
	var projectile = load("res://src/Projectiles/EnemyProjectile.tscn").instance()
	projectile.global_position = projectile_spawn_point.global_position
	projectile.direction = -direction
	add_child(projectile)
	current_state = STATES.IDLE
	direction = 0
		
func on_damage(damage):
	stats.current_hp = stats.current_hp - damage
	update_health_bar()
	if stats.current_hp < 20 and TILE_SIZE == 32:
		TILE_SIZE = 48
	if stats.current_hp <= 0:
		#play death animation
		die()
		
func update_health_bar():
	boss_health_bar.health_bar.value = stats.current_hp
	
func die():
	emit_signal("boss_defeated")
	queue_free()

func _on_Timer_timeout():
	if current_state == STATES.IDLE:
		player_coordinates = find_player()
		randomize()
		attacks.shuffle()
		match attacks[0]:
			STATES.DIVE_ATTACK:
				plunge_attack()
			STATES.THRUST_ATTACK:
				thrust_attack()
			STATES.PROJECTILE_ATTACK:
				projectile_attack()
	
func plunge_attack():
	current_state = STATES.DIVE_ATTACK
	self.global_position.x = player_coordinates.x
	self.global_position.y = player_coordinates.y - 256
	
func thrust_attack():
	current_state = STATES.THRUST_ATTACK
	find_a_corner()
	face_the_player()
	
func projectile_attack():
	current_state = STATES.PROJECTILE_ATTACK
	find_a_corner()
	face_the_player()
	
func find_a_corner():
	randomize()
	positions.shuffle()
	self.global_position = positions[0]
	
func face_the_player():
	if direction == 0:
		if player_coordinates.x > position.x:
			direction = 1
			sprite.scale.x = 1
		if player_coordinates.x < position.x:
			direction = -1
			sprite.scale.x = -1
	

