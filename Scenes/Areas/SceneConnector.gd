extends Node2D

export (String, "AreaA", "AreaB", "AreaC", "AreaD", "AreaE") var new_area
export var spawn_node : String

signal change_area()

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("Heading to scene %s at node %s" % [new_area, spawn_node])
		emit_signal("change_area", new_area, spawn_node)
