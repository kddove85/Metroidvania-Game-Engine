extends Control

onready var inventory_button = $Panel/VBoxContainer/Inventory
onready var abilities_button = $Panel/VBoxContainer/Abilities
onready var return_to_menu_button = $Panel/VBoxContainer/ReturnToMenu
onready var map_area_a = $Panel2/MapAreaA
onready var map_area_b = $Panel2/MapAreaB
onready var map_area_c = $Panel2/MapAreaC
onready var map_area_d = $Panel2/MapAreaD
onready var map_area_e = $Panel2/MapAreaE

onready var maps = [
	map_area_a, 
	map_area_b, 
	map_area_c, 
	map_area_d, 
	map_area_e
]
var current_map setget set_current_map

func _ready():
	hide()
	
func load_parameters(area_parameters: Dictionary):
	for area_name in area_parameters:
		if area_parameters[area_name] != null:
			for parameter in area_parameters[area_name]:
				if "Room" in parameter and area_parameters[area_name][parameter]:
					var room_name = parameter.split("_")
					get_node("Panel2/Map%s/Rooms/%s" % [area_name, room_name[1]]).visible = true
	
func set_current_map(area):
	current_map = get_node("Panel2/Map%s" % area)
	for map in maps:
		map.hide()
	current_map.show()

func open():
	show()
	inventory_button.grab_focus()
	get_tree().paused = true
	
func close():
	hide()
	get_tree().paused = false
