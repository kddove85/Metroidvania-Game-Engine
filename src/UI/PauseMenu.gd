extends Control

onready var inventory_button = $Panel/VBoxContainer/Inventory
onready var abilities_button = $Panel/VBoxContainer/Abilities
onready var return_to_menu_button = $Panel/VBoxContainer/ReturnToMenu

func _ready():
	hide()

func open():
	show()
	inventory_button.grab_focus()
	get_tree().paused = true
	
func close():
	hide()
	get_tree().paused = false
