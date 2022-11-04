extends Node2D

var abilities

func _ready():
	create_abilities()

func load_abilities(new_abilities: Dictionary):
	abilities = new_abilities
	
func create_abilities():
	if abilities == null:
		abilities = {}
	abilities["can_morph"] = false
	abilities["can_dash"] = false

func update_abilities(ability : String):
	pass
