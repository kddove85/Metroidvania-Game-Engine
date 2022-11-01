extends KinematicBody2D


onready var press_up = $PressUp

var is_player_in_shape = false
var dialogue_text = [
			{
				"text": "This is a sample to be overwritten." 
			},
			{
				"text": "If this text is still here in the final game then you have made a grave mistake." 
			},
		]

signal open_dialogue()

# Called when the node enters the scene tree for the first time.
func _ready():
	press_up.visible = false
	is_player_in_shape = false
	
func _input(_event):
	if is_player_in_shape and Input.is_action_just_pressed("ui_up"):
		emit_signal("open_dialogue", dialogue_text)
		get_tree().paused = true

func _on_InteractionArea_body_entered(body):
	if body.name == "Player":
		press_up.visible = true
		is_player_in_shape = true
		
func _on_InteractionArea_body_exited(body):
	if body.name == "Player":
		press_up.visible = false
		is_player_in_shape = false
