extends Node

# C:\Users\Kyle\AppData\Roaming\Godot\app_userdata\SimpleGame
const SAVE_PATH = "user://save_config_file.ini"

const AREA_A = "AreaA"
const AREA_B = "AreaB"
const AREA_C = "AreaC"
const AREA_D = "AreaD"
const AREA_E = "AreaE"

enum STATES {MAIN_MENU, IN_GAME_ACTIVE, IN_GAME_NOT_ACTIVE}

var user_interface = load("res://src/UI/UserInterface.tscn").instance()
var music = load("res://src/Main/Music.tscn").instance()
var music_menu = preload("res://assets/audio/mysterious-anomaly.mp3")
var music_boss = preload("res://assets/audio/CleytonRX - Battle RPG Theme.mp3")

var player = null
var player_parameters = null
var player_abilities = null

var area_parameters = {
	AREA_A: null,
	AREA_B: null,
	AREA_C: null,
	AREA_D: null,
	AREA_E: null
}

var activated_bonfires := []

var current_area
var current_bonfire
		
func _ready():
	create_save_file()
	load_menu()
			
func create_save_file():
	var file = File.new()
	if file.file_exists(ProjectSettings.globalize_path(SAVE_PATH)):
		print("file already exists")
	if not file.file_exists(ProjectSettings.globalize_path(SAVE_PATH)):
		file.open(SAVE_PATH, File.WRITE)
		print("Save file created")
	file.close()
	
func load_menu():
	var menu = load("res://src/UI/MainMenu.tscn").instance()
	menu.connect("new_game", self, "create_new_game")
	menu.connect("load_game", self, "on_load_game")
	menu.connect("options", self, "on_options")
	menu.connect("quit_game", self, "on_quit_game")
	add_child(menu)
	music.load_music(music_menu)
	add_child(music)
	
func create_new_game():
	add_user_interface()
	var area = get_area(AREA_A)
	add_area(area, {"type": "new_game"})
	on_update_level_parameters(AREA_A, area.level_parameters)
	on_update_player_parameters()
	on_update_player_abilities()
	save_game()
	get_node("MainMenu").queue_free()

func get_area(area):
	var area_to_load = load("res://src/Areas/%s.tscn" % area).instance()
	music.load_music(area_to_load.music)
	music.restart()
	return area_to_load

func add_area(area, dict):
	area.connect("open_item_acquired_box", self, "on_open_item_acquired_box")
	area.connect("open_bonfire_menu", self, "on_open_bonfire_menu")
	area.connect("update_level_parameters", self, "on_update_level_parameters")
	area.connect("area_entered", self, "on_area_entered")
	area.connect("bonfire_activated", self, "on_bonfire_activated")
	area.connect("play_boss_music", self, "on_play_boss_music")
	area.connect("display_boss_health_bar", self, "on_display_boss_health_bar")
	area.connect("boss_defeated", self, "on_boss_defeated")
	for connection in area.get_node("Connectors").get_children():
		connection.connect("change_area", self, "on_change_area")
	for npc in area.get_node("NPCs").get_children():
		npc.connect("open_dialogue", self, "on_open_dialogue")
	if area_parameters[area.name] != null:
		area.load_parameters(area_parameters[area.name])
	add_child(area)
	area.spawn_player(player_parameters, player_abilities)
	area.move_player(dict)
	
	player = area.get_node("Player")
	player.connect("game_over", self, "on_game_over")
	player.connect("update_hud", self, "on_update_hud")
	player.connect("update_player_parameters", self, "on_update_player_parameters")
	player.connect("update_player_abilities", self, "on_update_player_abilities")
	on_update_hud()
	
func on_update_hud():
	user_interface.hud.update_hud(player)
	
# TODO: Fix game over
func on_game_over():
	user_interface.play_game_over()
	user_interface.game_over.connect("reset", self, "on_reset")
	
func on_reset():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func on_update_level_parameters(area, new_area_parameters):
	print("on update level params")
	area_parameters[area] = new_area_parameters
	
# TODO: Fix variable shadowing
func on_update_player_parameters():
	player_parameters = {
		"max_hp": player.stats.max_hp,
		"current_hp": player.stats.current_hp
	}
	
# TODO: Fix variable shadowing
func on_update_player_abilities():
	player_abilities = player.abilities.abilities
	
func on_area_entered(area_name):
	current_area = area_name
	
# This is for the fast travel menu
func on_bonfire_activated(bonfire_object):
	activated_bonfires.append(bonfire_object)
			
func on_open_bonfire_menu(bonfire_name):
	current_bonfire = bonfire_name
	user_interface.open_bonfire_menu()
	user_interface.load_activated_bonfires(activated_bonfires)
	player.stats.current_hp = player.stats.max_hp
	player.stats.current_mp = player.stats.max_mp
	on_update_hud()
		
func on_bonfire_travel(destination):
	print("on bonfire travel")
	for bonfire in activated_bonfires:
		if bonfire.bonfire_custom_name == destination:
			if bonfire.area_name == current_area:
				current_bonfire = bonfire.bonfire_name
				var area = get_node(current_area)
				area.get_tree().paused = false
				area.move_player({"type": "bonfire", "bonfire": current_bonfire})
			else:
				var new_area = bonfire.area_name
				current_bonfire = bonfire.bonfire_name
				var current_area_node = get_node(current_area)
				current_area_node.queue_free()
				current_area_node.get_tree().paused = false
				var area = get_area(new_area)
				add_area(area, {"type": "bonfire", "bonfire": current_bonfire})
				
func on_play_boss_music():
	music.load_music(music_boss)
	music.volume_db = 0
	music.play()
	
func on_display_boss_health_bar(boss):
	user_interface.set_boss_health_bar(boss)
	boss.connect("update_health_bar", self, "on_update_boss_health_bar")
	
func on_update_boss_health_bar(boss):
	user_interface.boss_health_bar.health_bar.value = boss.stats.current_hp
	
func on_boss_defeated():
	user_interface.boss_health_bar.hide()
	music.load_music(get_node(current_area).music)
	music.restart()
				
func on_change_area(new_area, new_node):
	var current_area_node = get_node(current_area)
	current_area_node.queue_free()
	current_area_node.get_tree().paused = false
	var area = get_area(new_area)
	add_area(area, {"type": "connector", "new_node": new_node})
	
func on_open_dialogue(dialogue):
	user_interface.load_dialogue(dialogue)
	user_interface.start_dialogue()
	
func on_open_item_acquired_box(text):
#	var item_acquired_box = load("res://src/UI/ItemAcquiredBox.tscn").instance()
#	add_child(item_acquired_box)
	user_interface.load_item_acquired_text(text)
	user_interface.start_item_acquired()
#	item_acquired_box.animation_player.play("Open")
		
func save_game():
	print("game saved")
	var config = ConfigFile.new()
	config.set_value("player", "player_params", player_parameters)
	config.set_value("player", "player_abilities", player_abilities)
	config.set_value("area", "current_area", current_area)
	config.set_value("area", "current_bonfire", current_bonfire)
	config.set_value("bonfires", "activated_bonfires", activated_bonfires)
	config.set_value(AREA_A, "area_parameters", area_parameters[AREA_A])
	config.set_value(AREA_B, "area_parameters", area_parameters[AREA_B])
	config.set_value(AREA_C, "area_parameters", area_parameters[AREA_C])
	config.set_value(AREA_D, "area_parameters", area_parameters[AREA_D])
	config.set_value(AREA_E, "area_parameters", area_parameters[AREA_E])
	config.save(SAVE_PATH)
	
func on_load_game():
	add_user_interface()
	get_node("MainMenu").queue_free()
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	current_area = config.get_value("area", "current_area")
	current_bonfire = config.get_value("area", "current_bonfire") if config.get_value("area", "current_bonfire", "none") != "none" else null
	activated_bonfires = config.get_value("bonfires", "activated_bonfires")
	player_parameters = config.get_value("player", "player_params")
	player_abilities = config.get_value("player", "player_abilities")
	area_parameters[AREA_A] = config.get_value(AREA_A, "area_parameters") if config.get_value(AREA_A, "area_parameters", "none") is Dictionary else null
	area_parameters[AREA_B] = config.get_value(AREA_B, "area_parameters") if config.get_value(AREA_B, "area_parameters", "none") is Dictionary else null
	area_parameters[AREA_C] = config.get_value(AREA_C, "area_parameters") if config.get_value(AREA_C, "area_parameters", "none") is Dictionary else null
	area_parameters[AREA_D] = config.get_value(AREA_D, "area_parameters") if config.get_value(AREA_D, "area_parameters", "none") is Dictionary else null
	area_parameters[AREA_E] = config.get_value(AREA_E, "area_parameters") if config.get_value(AREA_E, "area_parameters", "none") is Dictionary else null
	var area = get_area(current_area)
	add_area(area, {"type": "load_game", "bonfire": current_bonfire})
	
func add_user_interface():
	add_child(user_interface)
#	user_interface.bonfire_menu.connect("travel", self, "on_bonfire_travel")
	user_interface.bonfire_menu.connect("save", self, "save_game")
	user_interface.bonfire_travel_menu.connect("warp", self, "on_bonfire_travel")
	
func on_options():
	print("options")
	
func on_quit_game():
	get_tree().quit()
