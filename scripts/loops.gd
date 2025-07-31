extends Node
class_name Loops

@onready var bass:AudioStreamPlayer = $Bass
@onready var drums:AudioStreamPlayer = $Drums
var bass_playing:bool = true
var drums_playing:bool = true
var lead_playing:bool = false
var pad_playing:bool = false
var current_time:float = 0.0
var last_time:float = 0.0

func _ready():
	play()

func _physics_process(delta: float) -> void:
	last_time = current_time
	current_time += delta
	play_with_check()
	
func play_with_check(delta:float = 0.0):
	var reset_loop:bool
	var current_beat:int = floor(current_time*2.0)
	if current_beat % 16 == 0:
		var last_beat:int =floor(last_time*2.0) 
		if current_beat != last_beat:
			play(delta)

func play(delta:float = 0):
	if bass_playing:
		bass.play(delta)
	if drums_playing:
		drums.play(delta)
				
		

func reset_music():
	current_time = 0.0
	last_time = 0.0
