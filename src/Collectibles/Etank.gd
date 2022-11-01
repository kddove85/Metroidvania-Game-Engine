extends Area2D

var id : String
var type = "etank"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_collected_item()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ETank_body_entered(body):
	if body.name == "Player":
		emit_signal("player_collected_item", type, id)
		self.queue_free()
