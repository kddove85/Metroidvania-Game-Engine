extends CanvasLayer

onready var save = $Control/VBoxContainer/Save
onready var travel = $Control/VBoxContainer/Travel
onready var game_saved_label = $Control/GameSaved
onready var timer = $Timer

var activated_bonfires := []

signal save()
signal travel()

func _ready():
	game_saved_label.visible = false
	save.grab_focus()

func load_activated_bonfires(bonfires: Array):
	activated_bonfires = bonfires

func _on_Save_pressed():
	game_saved_label.visible = true
	timer.start()
	emit_signal("save")
	
func _on_Timer_timeout():
	game_saved_label.visible = false

func _on_Travel_pressed():
	var bonfire_travel_menu = load("res://src/UI/BonfireTravelMenu.tscn").instance()
	bonfire_travel_menu.connect("grant_focus", self, "on_grant_focus")
	bonfire_travel_menu.connect("travel", self, "on_travel")
	add_child(bonfire_travel_menu)
	bonfire_travel_menu.load_activated_bonfires(activated_bonfires)
	
func on_grant_focus():
	travel.grab_focus()
	
func on_travel(destination):
	emit_signal("travel", destination)
	self.queue_free()
	
func _on_LeaveBonfire_pressed():
	get_tree().paused = false
	self.queue_free()
