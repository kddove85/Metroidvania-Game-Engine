extends Node2D

signal update_level_parameters()
signal update_player_parameters()
signal update_player_abilities()
signal area_entered()
signal open_bonfire_menu()
signal open_item_acquired_box()
signal bonfire_activated()
signal play_boss_music()
signal display_boss_health_bar()
signal boss_defeated()

const HEALTH_DROP_VALUE = 10

var ETANK = "ETank"
var etank = load("res://src/Collectibles/ETank.tscn")

var level_parameters
var health_drop
var is_boss_spawned = false
var rooms := []

onready var boss_spawn_point = $BossSpawnPoint

export var custom_name : String
export var boss : PackedScene
export var music : AudioStreamMP3

func _ready():
	emit_signal("area_entered", name)
	create_level_params()
	spawn_collectibles()
	connect_bonfires()
	connect_gates()
	for room in get_node("Rooms").get_children():
		rooms.append(room)
		room.connect("player_entered_room", self, "on_player_entered_room")
	
# load parameters is only called on load game
func load_parameters(new_level_parameters: Dictionary):
	level_parameters = new_level_parameters
	
func create_level_params():
	var is_level_parameters_set = true
	if level_parameters == null:
		is_level_parameters_set = false
		level_parameters = {}
	if !is_level_parameters_set:
		var collectibles = get_node("Collectibles").get_children()
		for collectible in collectibles:
			level_parameters["is_%s_collected" % collectible.id] = false
		var bonfires = get_node("Bonfires").get_children()
		for bonfire in bonfires:
			level_parameters["is_%s_activated" % bonfire.name] = false
		var gates = get_node("Gates").get_children()
		for gate in gates:
			level_parameters["is_%s_activated" % gate.name] = false
		level_parameters["is_boss_defeated"] = false
		var _rooms = get_node("Rooms").get_children()
		for room in _rooms:
			level_parameters["is_%s_entered" % room.name] = false
			
func spawn_player(player_parameters, player_abilities):
	var player = load("res://src/Actors/Player/Player.tscn").instance()
	add_child(player)
	if player_parameters != null:
		player.stats.max_hp = player_parameters["max_hp"]
		player.stats.current_hp = player_parameters["current_hp"]
	else:
		emit_signal("update_player_parameters", player)
		
	if player_abilities != null:
		player.abilities.abilities = player_abilities
	else:
		emit_signal("update_player_abilities")
	
func move_player(dict):
	var player = get_node("Player")
	match dict.type:
		"new_game":
			player.global_position = get_node("PlayerSpawnPoints/PlayerSpawnPointA").get_position()
		"load_game", "bonfire":
			if dict.bonfire != null:
				player.global_position = get_node("Bonfires/%s" % dict.bonfire).get_position()
			else:
				player.global_position = get_node("PlayerSpawnPoints/PlayerSpawnPointA").get_position()
		"connector":
			player.global_position = get_node(dict.new_node).get_position()
		
# This will dynamically build my level parameters as long as I fill
# out my Area_A Collectibles with Spawn Points of Items
func spawn_collectibles():
	var children = get_node("Collectibles").get_children()
	for child in children:
		if !level_parameters["is_%s_collected" % child.id]:
			spawn_collectible(child)

func spawn_collectible(child):
	var collectible_instance = child.item_to_spawn.instance()
	collectible_instance.id = child.id
	collectible_instance.type = child.type
	collectible_instance.connect("player_collected_item", self, "on_player_collected_item")
	collectible_instance.global_position = child.get_position()
	add_child(collectible_instance)

func connect_bonfires():
	var bonfires = get_node("Bonfires").get_children()
	for bonfire in bonfires:
		bonfire.connect("open_bonfire_menu", self, "on_open_bonfire_menu")
		bonfire.connect("bonfire_activated", self, "on_bonfire_activated")
		if level_parameters["is_%s_activated" % bonfire.name]:
			bonfire.is_activated = true
			bonfire.particles.emitting = true

func on_player_entered_room(room_name):
	level_parameters["is_%s_entered" % room_name] = true

func on_open_bonfire_menu(bonfire_name):
	emit_signal("open_bonfire_menu", bonfire_name)
	var player = get_node("Player")
	player.stats.current_hp = player.stats.max_hp
	player.stats.current_mp = player.stats.max_mp
	get_tree().paused = true
	
func on_bonfire_activated(bonfire):
	level_parameters["is_%s_activated" % bonfire.name] = true
	emit_signal("update_level_parameters", self.name, level_parameters)
	var bonfire_object = {
		"area_name": self.name,
		"area_custom_name": self.custom_name,
		"bonfire_name": bonfire.name,
		"bonfire_custom_name": bonfire.custom_name
	}
	emit_signal("bonfire_activated", bonfire_object)
	
func connect_gates():
	var gates = get_node("Gates").get_children()
	for gate in gates:
		gate.connect("gate_activated", self, "on_gate_activated")
		if level_parameters["is_%s_activated" % gate.name]:
			gate.activate_gate()
			
func on_gate_activated(gate):
	level_parameters["is_%s_activated" % gate.name] = true
	emit_signal("update_level_parameters", self.name, level_parameters)
	
func on_player_collected_item(type, id, text):
	level_parameters["is_%s_collected" % id] = true
	get_node("Player").item_collected(type)
	emit_signal("open_item_acquired_box", text)
	emit_signal("update_level_parameters", self.name, level_parameters)
	print("on player collected item")
	
func spawn_boss():
	var area_boss = boss.instance()
	area_boss.global_position = boss_spawn_point.global_position
	area_boss.connect("boss_defeated", self, "on_boss_defeated")
	add_child(area_boss)
	is_boss_spawned = true
	emit_signal("play_boss_music")
	emit_signal("display_boss_health_bar", area_boss)
	
func _spawn_boss():
	pass
	
func on_boss_defeated():
	print("boss defeated")
	level_parameters["is_boss_defeated"] = true
	for boss_gate in get_node("BossGates").get_children():
		boss_gate.queue_free()
	emit_signal("boss_defeated")

#func on_player_touched_drop():
#	emit_signal("drop_got", HEALTH_DROP_VALUE)
#
#func connect_etank(spawn_point):
#	var etank_instance = etank.instance()
#	etank_instance.id = spawn_point
#	etank_instance.connect("player_touched", self, "on_player_touched_etank")
#	etank_instance.global_position = get_node(spawn_point).get_position()
#	add_child(etank_instance)
#
## Does this need to go in Game Manager?
#func connect_drop(spawn_point):
#	var health_drop_instance = health_drop.instance()
#	health_drop_instance.connect("player_touched", self, "on_player_touched_drop")
#	health_drop_instance.global_position = get_node(spawn_point).get_position()
#	add_child(health_drop)


func _on_BossTrigger_body_entered(body):
	if body.name == "Player" and !level_parameters["is_boss_defeated"] and !is_boss_spawned:
		for boss_gate in get_node("BossGates").get_children():
			boss_gate.global_position.y = boss_gate.global_position.y + 128
		spawn_boss()
