extends Node
class_name Loops

@onready var tracks:Dictionary = {"kick":{"playing":true,"player":$Kick},
								 	"snare":{"playing":false,"player":$Snare},
									"hats":{"playing":false,"player":$Hats},
									"pads":{"playing":true,"player":$Pads},
									"bass":{"playing":false,"player":$Bass},
									"lead":{"playing":false,"player":$Leads},
									"fx":{"playing":false,"player":$FX},
									"other":{"playing":false,"player":$Other}
}

var kick_playing:bool:
	get:
		return tracks["kick"]["playing"]
	set(new_val):
		tracks["kick"]["playing"] = new_val
var snare_playing:bool:
	get:
		return tracks["snare"]["playing"]
	set(new_val):
		tracks["snare"]["playing"] = new_val
var hats_playing:bool:
	get:
		return tracks["hats"]["playing"]
	set(new_val):
		tracks["hats"]["playing"] = new_val
var pads_playing:bool:
	get:
		return tracks["pads"]["playing"]
	set(new_val):
		tracks["pads"]["playing"] = new_val
var bass_playing:bool:
	get:
		return tracks["bass"]["playing"]
	set(new_val):
		tracks["bass"]["playing"] = new_val
var lead_playing:bool:
	get:
		return tracks["lead"]["playing"]
	set(new_val):
		tracks["lead"]["playing"] = new_val
var fx_playing:bool:
	get:
		return tracks["fx"]["playing"]
	set(new_val):
		tracks["fx"]["playing"] = new_val

var other_playing:bool:
	get:
		return tracks["other"]["playing"]
	set(new_val):
		tracks["other"]["playing"] = new_val
		
		
var current_time:float = 0.0
var current_beat:float = 0.0
var last_time:float = 0.0

func _ready():
	play()

func _physics_process(delta: float) -> void:
	last_time = current_time
	current_time += delta
	current_beat = current_time*2.0
	play_with_check()
	
func play_with_check(delta:float = 0.0):
	var reset_loop:bool
	var current_beat_int:int = floor(current_beat)
	if current_beat_int % 16 == 0:
		var last_beat_int:int =floor(last_time*2.0) 
		if current_beat_int != last_beat_int:
			play(delta)

func play(delta:float = 0.0):
	for k in tracks.keys():
		if tracks[k]["playing"]:
			tracks[k]["player"].play(delta)


func reset_music():
	current_time = 0.0
	last_time = 0.0
	for k in tracks.keys():
		tracks[k]["playing"]= false
	tracks["kick"]["playing"]= true
	tracks["pads"]["playing"]= true
