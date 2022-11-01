extends "res://src/Actors/Hitbox.gd"

export var TILE_SIZE : int
export var SPEED : int
export var GRAVITY : int

var motion = Vector2()
var direction = 1

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	motion.x = SPEED * TILE_SIZE * delta * direction
	translate(motion)
	
func set_direction(new_direction):
	direction = new_direction
	if direction < 0:
		$AnimatedSprite.flip_h = true
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_GenericProjectile_area_entered(_area):
	queue_free()
