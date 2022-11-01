extends CanvasLayer

onready var vbox = $Control/VBoxContainer

signal grant_focus()
signal travel()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func load_activated_bonfires(activated_bonfires: Array):
	for bonfire in activated_bonfires:
		add_bonfire_button(bonfire)
	if vbox.get_child_count() > 0:
		print("Grabbing Focus")
		vbox.get_child(0).grab_focus()
		
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("grant_focus")
		self.queue_free()
		
func add_bonfire_button(bonfire):
	var button = Button.new()
	button.flat = true
	button.text = bonfire.bonfire_custom_name
	button.connect("pressed", self, "on_pressed", [ button ])
	vbox.add_child(button)
	
func on_pressed(button):
	emit_signal("travel", button.text)
	self.queue_free()
