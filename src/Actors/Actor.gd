extends KinematicBody2D

export var TILE_SIZE : int
export var WALK_SPEED : int
export var JUMP_FORCE : int
export var GRAVITY : int

var motion = Vector2()
onready var speed = Vector2(TILE_SIZE * WALK_SPEED, TILE_SIZE * JUMP_FORCE)
onready var gravity = TILE_SIZE * GRAVITY

onready var sprite = $AnimatedSprite
onready var hurtboxes = $Hurtboxes
onready var stats = $Stats

var is_invincible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_invincible = false
	for hurtbox in hurtboxes.get_children():
		hurtbox.connect("damage", self, "on_damage")
		hurtbox.connect("invincibility_started", self, "on_invincibility_started")
		hurtbox.connect("invincibility_ended", self, "on_invincibility_ended")
		
func blink():
	if is_invincible:
		sprite.visible = !sprite.visible	

func on_invincibility_started():
	is_invincible = true
	
func on_invincibility_ended():
	is_invincible = false
	sprite.visible = true
