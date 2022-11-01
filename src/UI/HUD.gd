extends CanvasLayer

onready var health_bar = $HealthBar
onready var magic_bar = $MagicBar

func _ready():
	pass

func update_hud(player):
	health_bar.max_value = player.stats.max_hp
	health_bar.value = player.stats.current_hp
	health_bar.rect_size.x = player.stats.max_hp / 2
	
	magic_bar.max_value = player.stats.max_mp
	magic_bar.value = player.stats.current_mp
	magic_bar.rect_size.x = player.stats.max_mp / 2
