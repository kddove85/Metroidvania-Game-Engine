extends CanvasLayer

onready var animation_player = $AnimationPlayer
var is_ready = false
signal reset()


# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func play():
	animation_player.play("Play")

func _on_AnimationPlayer_animation_finished(anim_name):
	is_ready = true
	
func _input(_event):
	if is_ready:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_start"):
			emit_signal("reset")
