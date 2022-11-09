extends Node2D

export var custom_name : String

onready var gate = $Gate
onready var lever = $Lever
onready var press_up = $Lever/PressUp

var is_activated := false
var is_player_in_shape := false

signal gate_activated()

func _ready():
	press_up.visible = false

func _input(_event):
	if is_player_in_shape and !is_activated and Input.is_action_just_pressed("ui_up"):
		activate_gate()
		
func activate_gate():
	is_activated = true
	gate.visible = false
	gate.get_node("CollisionShape2D").disabled = true
	lever.get_node("Sprite").flip_h = true
	emit_signal("gate_activated", self)

func _on_Lever_body_entered(body):
	if body.name == "Player":
		press_up.visible = true
		is_player_in_shape = true
		
func _on_Lever_body_exited(body):
	if body.name == "Player":
		press_up.visible = false
		is_player_in_shape = false
