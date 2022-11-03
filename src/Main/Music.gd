extends AudioStreamPlayer

onready var tween = $Tween

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	restart()
	
func load_music(audio_stream):
	volume_db = -80
	stream = audio_stream
	stream.loop = true
	
func restart():
	play()
	tween.interpolate_property(self, "volume_db", -80, 0, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(volume_db)
