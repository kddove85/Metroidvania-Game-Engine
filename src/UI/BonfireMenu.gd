extends Control

onready var save = $VBoxContainer/Save
onready var travel = $VBoxContainer/Travel
onready var game_saved_label = $GameSaved
onready var timer = $Timer

var activated_bonfires := []

signal save()

func _ready():
	game_saved_label.visible = false
	hide()
	
func open():
	show()
	save.grab_focus()
	get_tree().paused = true
	
func close():
	get_tree().paused = false
	hide()

func _on_Save_pressed():
	game_saved_label.visible = true
	timer.start()
	emit_signal("save")
	
func _on_Timer_timeout():
	game_saved_label.visible = false
	
#func on_travel(destination):
#	emit_signal("travel", destination)
##	self.queue_free()
	
func _on_LeaveBonfire_pressed():
	close()
