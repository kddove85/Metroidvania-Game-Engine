extends Node2D

onready var enemy_spawn_points = $EnemySpawnPoints
onready var enemies = $Enemies


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.name == "RoomDetector":
		for enemy_spawn_point in enemy_spawn_points.get_children():
			var enemy = enemy_spawn_point.enemy.instance()
			enemies.add_child(enemy)
			enemy.global_position = enemy_spawn_point.global_position

func _on_Area2D_area_exited(area):
	if area.name == "RoomDetector":
		print("RoomDetector exited")
		for enemy in enemies.get_children():
			enemy.queue_free()
			
func add_enemy():
	pass
		
