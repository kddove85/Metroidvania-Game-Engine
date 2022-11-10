extends Control

# Nodes
onready var rtl = $Panel/RichTextLabel
onready var aniplayer = $Panel/AnimationPlayer

# Enums
enum state {OPENING, ACTIVE, CLOSING, CLOSED}

# Member Variables
onready var current_state = state.CLOSED
onready var page = 0

var text

func _ready():
	pass

func load_text(new_text):
	text = new_text

func _input(event):
	if text != null:
		continue_text(event, text)

func start():
	open()
	
func get_text(dialog):
	print("here")
	rtl.set_bbcode(dialog[page]["text"])
	rtl.set_visible_characters(0)
	rtl.set_process_input(true)
	
func open():
	var previous_state = current_state
	if previous_state == state.CLOSED:
		aniplayer.play("Open")
		current_state = state.OPENING
		
func continue_text(event, dialog):
	var previous_state = current_state
	if previous_state == state.ACTIVE and not aniplayer.is_playing():
		if event.is_action_pressed("ui_accept"):
			if rtl.get_visible_characters() > rtl.get_total_character_count():
				if page < dialog.size() - 1:
					page += 1
					rtl.set_bbcode(dialog[page]["text"])
					rtl.set_visible_characters(0)
				else:
					close()
		elif event.is_action_pressed("ui_start"):
			rtl.set_visible_characters(rtl.get_total_character_count())
		current_state = state.ACTIVE
	
func close():
	aniplayer.play("Close")
	current_state = state.CLOSING

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Open":
		var previous_state = current_state
		if previous_state == state.OPENING:
			current_state = state.ACTIVE
		get_text(text)
	if anim_name == "Close":
		page = 0
		rtl.clear()
		current_state = state.CLOSED
		get_tree().paused = false

func _on_Timer_timeout():
	rtl.set_visible_characters(rtl.get_visible_characters() + 1)

