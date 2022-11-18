extends Control

onready var rooms = $Rooms

# Called when the node enters the scene tree for the first time.
func _ready():
	for room in rooms.get_children():
		room.get_node("TileMap").set_modulate(Color("3741da"))
		room.hide()

func show_room(room_name):
	rooms.get_node(room_name).show()
	rooms.get_node(room_name).get_node("TileMap").set_modulate(Color("79f179"))
	
func leave_room(room_name):
	rooms.get_node(room_name).get_node("TileMap").set_modulate(Color("3741da"))
