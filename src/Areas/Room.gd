extends Node2D

onready var enemy_spawn_points = $EnemySpawnPoints
onready var enemies = $Enemies
onready var parallax_layer = $ParallaxBackground/ParallaxLayer

signal player_entered_room()
signal player_left_room()

# Called when the node enters the scene tree for the first time.
func _ready():
	parallax_layer.visible = false

func _on_Area2D_area_entered(area):
	if area.name == "RoomDetector":
		for enemy_spawn_point in enemy_spawn_points.get_children():
			var enemy = enemy_spawn_point.enemy.instance()
			enemies.add_child(enemy)
			enemy.global_position = enemy_spawn_point.global_position
		emit_signal("player_entered_room", name)
		parallax_layer.visible = true

func _on_Area2D_area_exited(area):
	if area.name == "RoomDetector":
		print("RoomDetector exited")
		for enemy in enemies.get_children():
			enemy.queue_free()
		emit_signal("player_left_room", name)
		parallax_layer.visible = false
			
func add_enemy():
	pass
		
