extends Node
class_name Loops
@onready var decks:Array[AudioStreamPlayer] = [$DrumNBassDeck,$LeadDeck]

enum drum_attacks {STANDARD, SLOW, AOE, DOT}
enum lead_attacks {STANDARD, PIERCE, MULTI, FAST}

signal drum_attack_changed(new_attack:drum_attacks)
signal lead_attack_changed(new_attack:lead_attacks)


signal beat(beat_number:int, measure:int, sixteen: int)
@onready var drum_n_bass_tracks:Array = [
	preload("res://assets/loops/drumNBass1.mp3"),
	preload("res://assets/loops/drumNBass2.mp3"),
	preload("res://assets/loops/drumNBass3.mp3"),
	preload("res://assets/loops/drumNBass4.mp3")
	]
@onready var lead_tracks:Array = [
	preload("res://assets/loops/lead1.mp3"),
	preload("res://assets/loops/lead2.mp3"),
	preload("res://assets/loops/lead3.mp3"),
	preload("res://assets/loops/lead4.mp3")
	]
var deck_queued:Array[bool] = [false,false]
var deck_queued_track:Array[int] = [0,0]
var playing_drum_attack = drum_attacks.STANDARD
var playing_lead_attack =  lead_attacks.STANDARD	

		
var current_time:float = 0.0
var current_beat:float = 0.0
var last_time:float = -1.0
var deck_beats:Array[int] = [0,0]

func _ready():
	play(0)
	play(1)

func _physics_process(delta: float) -> void:
	last_time = current_time
	current_time += delta
	current_beat = current_time*2.0
	play_with_check()
	
func play_with_check():
	var current_beat_int:int = floor(current_beat)
	var last_beat_int:int =floor(last_time*2.0)
	if current_beat_int != last_beat_int:
		beat.emit(current_beat_int+1,(current_beat_int%4)+1,(current_beat_int%16)+1 )
		deck_beats[0] += 1
		deck_beats[1] += 1
		print("current_beat: %s-%s-%s		deck_one: %s		deck_two: %s" % [current_beat_int+1,(current_beat_int%4)+1,(current_beat_int%16)+1,deck_beats[0],deck_beats[1]])
		if current_beat_int % 4 == 0:
			for i in 2:
				if deck_queued[i]:
					decks[i].stop()
					load_track(i,deck_queued_track[i])
					deck_beats[i] = 0
					decks[i].play()
					deck_queued[i] = false
				elif deck_beats[i] == 16:
					deck_beats[i] = 0
					decks[i].play()

func play(deck_id:int = 0):
	decks[deck_id].play()

func reset_music():
	current_time = 0.0
	last_time = 0.0
	decks[0].stop()
	decks[1].stop()
	
func load_track(deck_id:int =0, track_id:int = 0):
	if deck_id == 0:
		decks[deck_id].stream = drum_n_bass_tracks[track_id]
		drum_attack_changed.emit(track_id)
	else:
		decks[deck_id].stream = lead_tracks[track_id]
		lead_attack_changed.emit(track_id)
