extends "res://Scenes/Actors/Enemies/Enemy.gd"

onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var projectile_spawn_point = $ProjectileSpawnPoint


func _ready():
	motion.x = speed.x
	
func _physics_process(_delta):
	move()

func move():
	# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
	if not floor_detector_left.is_colliding():
		motion.x = speed.x
	elif not floor_detector_right.is_colliding():
		motion.x = -speed.x

	if is_on_wall():
		print("On a wall")
		motion.x *= -1

	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	motion.y = move_and_slide(motion, Vector2.UP).y

	# We flip the Sprite depending on which way the enemy is moving.
	if motion.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1


func _on_Timer_timeout():
	var projectile = load("res://Scenes/Projectiles/EnemyProjectile.tscn").instance()
	projectile.global_position = projectile_spawn_point.global_position
#	projectile.set_as_toplevel(true)
	add_child(projectile)
