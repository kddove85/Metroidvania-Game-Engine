extends Control

signal new_game()
signal load_game()
signal options()
signal quit_game()

onready var new_game = $VBoxContainer/NewGame

func _ready():
	new_game.grab_focus()

func _on_NewGame_pressed():
	emit_signal("new_game")
	
func _on_LoadGame_pressed():
	emit_signal("load_game")

func _on_Options_pressed():
	emit_signal("options")

func _on_QuitGame_pressed():
	emit_signal("quit_game")
