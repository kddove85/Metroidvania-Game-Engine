extends Area2D

export var text : String

var type : String
var id : String

signal player_collected_item()

func _ready():
	pass # Replace with function body.
	
func set_id(new_id):
	id = new_id

func _on_Collectible_body_entered(body):
	if body.name == "Player":
		emit_signal("player_collected_item", type, id, text)
		get_tree().paused = true
		self.queue_free()
