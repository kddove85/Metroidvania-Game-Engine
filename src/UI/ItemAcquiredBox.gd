extends Control

enum STATES {OPENING, ACTIVE, CLOSING, CLOSED}

onready var text_box = $Panel/RichTextLabel
onready var animation_player = $Panel/AnimationPlayer

var current_state = STATES.CLOSED 


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func load_text(new_text):
	text_box.text = new_text

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and current_state == STATES.ACTIVE:
		text_box.visible = false
		animation_player.play("Close")
		current_state = STATES.CLOSING
		
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Open":
		text_box.visible = true
		current_state = STATES.ACTIVE
	if anim_name == "Close":
		current_state = STATES.CLOSED
		get_tree().paused = false
		self.queue_free()
