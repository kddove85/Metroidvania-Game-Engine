extends Control

onready var vbox = $ScrollContainer/VBoxContainer

signal grant_focus()
signal warp()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func open(bonfires):
	load_activated_bonfires(bonfires)
	show()

func load_activated_bonfires(activated_bonfires: Array):
	for bonfire in activated_bonfires:
		add_bonfire_button(bonfire)
	if vbox.get_child_count() > 0:
		vbox.get_child(0).grab_focus()
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		emit_signal("grant_focus")
		clear_activated_bonfires()
		hide()
		
func clear_activated_bonfires():
	for bonfire in vbox.get_children():
		bonfire.queue_free()
		
func add_bonfire_button(bonfire):
	var button = Button.new()
	button.flat = true
	button.text = bonfire.bonfire_custom_name
	button.connect("pressed", self, "on_pressed", [ button ])
	vbox.add_child(button)
	
func on_pressed(button):
	clear_activated_bonfires()
	hide()
	emit_signal("warp", button.text)
