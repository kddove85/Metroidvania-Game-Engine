extends Area2D

signal invincibility_started()
signal invincibility_ended()
signal damage()

const HIT_EFFECT = null

onready var timer = $iFrameTimer

var is_invincible = false setget set_invincible

func set_invincible(value):
	is_invincible = value
	if is_invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_iframes(duration):
	self.is_invincible = true
	timer.start(duration)

func create_hit_effect(_area):
	pass
#	var effect_instance = HIT_EFFECT.instance()
#	var main_scene = get_tree().current_scene
#	main_scene.add_child(effect_instance)
#	effect_instance.global_position = global_position

#func _on_HurtBox_invincibility_started():
#	set_deferred("monitorable", false)

#func _on_HurtBox_invincibility_ended():
#	monitorable = true

func _on_iFrameTimer_timeout():
	monitorable = true
	is_invincible = false
	emit_signal("invincibility_ended")

func _on_HurtBox_area_entered(area):
	if !is_invincible:
		print(area.name)
		emit_signal("damage", area.damage)
		is_invincible = true
		emit_signal("invincibility_started")
		set_deferred("monitorable", false)
		timer.start()
