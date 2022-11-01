extends "res://src/NPCs/NPC.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_text = [
			{
				"text": "Hi, I'm Ben." 
			},
			{
				"text": "Good luck on your journey." 
			},
		]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
