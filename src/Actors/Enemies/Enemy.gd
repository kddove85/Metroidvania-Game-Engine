extends "res://src/Actors/Actor.gd"

onready var player_scan_area = $PlayerScanArea

var current_state
var player_coordinates
var direction = 0

func on_damage(damage):
	stats.current_hp = stats.current_hp - damage
	if stats.current_hp <= 0:
		#play death animation
		queue_free()

func _on_Hitbox_area_entered(area):
	if area.get_parent().name == "Player":
		pass
		
func find_player():
	var overlapping_bodies = player_scan_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.name == "Player":
			return body.global_position
