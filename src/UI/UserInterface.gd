extends CanvasLayer

onready var bonfire_menu = $BonfireMenu
onready var bonfire_travel_menu = $BonfireTravelMenu
onready var hud = $HUD
onready var item_acquired_box = $ItemAcquiredBox
onready var dialogue_box = $DialogueBox
onready var pause_menu = $PauseMenu

var is_pause_menu_open := false
var can_pause_menu_be_opened := true
var activated_bonfires := []

# Called when the node enters the scene tree for the first time.
func _ready():
	bonfire_travel_menu.connect("warp", self, "on_warp")
	bonfire_travel_menu.connect("grant_focus", self, "on_grant_focus")
	is_pause_menu_open = false
	can_pause_menu_be_opened = true
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_start") and !is_pause_menu_open and can_pause_menu_be_opened:
		pause_menu.open()
		is_pause_menu_open = true
	elif event.is_action_pressed("ui_start") and is_pause_menu_open:
		pause_menu.close()
		is_pause_menu_open = false
	get_tree().set_input_as_handled()
	
func open_bonfire_menu():
	bonfire_menu.open()
	can_pause_menu_be_opened = false
	
func load_activated_bonfires(bonfires: Array):
	activated_bonfires = bonfires

func on_grant_focus():
	bonfire_menu.travel.grab_focus()

func on_warp(_text):
	bonfire_menu.close()

func _on_BonfireMenu_hide():
	can_pause_menu_be_opened = true

func _on_Travel_pressed():
	bonfire_travel_menu.open(activated_bonfires)
