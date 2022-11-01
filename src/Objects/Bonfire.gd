extends Area2D

export var custom_name : String
export var is_activated := false

onready var particles = $Particles2D
onready var press_up = $PressUp

var is_player_in_shape = false

signal open_bonfire_menu()
signal bonfire_activated()
signal heal_player()


func _ready():
	press_up.visible = false
	if is_activated:
		particles.emitting = true

func _input(_event):
	if is_player_in_shape and Input.is_action_just_pressed("ui_up") and $Timer.is_stopped():
		if is_activated:
			emit_signal("open_bonfire_menu", self.name)
			emit_signal("heal_player")
		else:
			$Timer.start()
			particles.emitting = true
			emit_signal("bonfire_activated", self)	
	
func _on_Bonfire_body_entered(body):
	if body.name == "Player":
		is_player_in_shape = true
		press_up.visible = true
		
func _on_Bonfire_body_exited(body):
	if body.name == "Player":
		is_player_in_shape = false
		press_up.visible = false

func _on_Timer_timeout():
	is_activated = true
