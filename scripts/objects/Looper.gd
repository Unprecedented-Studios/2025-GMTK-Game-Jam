extends Node
class_name Loops

@onready var decks:Array[AudioStreamPlayer] = [$DrumNBassDeck,$LeadDeck]


enum drum_attacks {STANDARD, SLOW, AOE, DOT}
enum lead_attacks {STANDARD, PIERCE, MULTI, FAST}
#enum sample_attacks {STANDARD, SLOW, AOE, DOT, PIERCE, MULTI, FAST}


signal drum_attack_changed(new_attack:drum_attacks)
signal lead_attack_changed(new_attack:lead_attacks)

var playing:bool = false
var countdown:bool = false
var flashy:bool = true
var synced:bool = true

signal beat(beat_number:int, measure:int, sixteen: int)
signal count_off(number:int)
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
var countdown_fast: bool = false

func _ready():
	flashy = not Config.get_config(&'VideoSettings', 'DISABLE_FLASHING', false);

func start_playing():
	playing = false;
	countdown = true
	current_time = -1

func _physics_process(delta: float) -> void:
	last_time = current_time
	current_time += delta
	current_beat = current_time*2.0
	
	if playing:
		play_with_check()
	elif countdown:
		_countdown_process()

func _countdown_process():
	var current_beat_int:int = floor(current_beat)
	var last_beat_int:int =floor(last_time*2.0)
	if current_beat_int != last_beat_int:
		var _call_number = '-';
		if countdown_fast:
			if (current_beat_int%16 == 8):
				countdown_fast = false;
				countdown = false;
				playing = true
				play()
				play_with_check()
				return
			var count = (current_beat_int%4)+1
			count_off.emit(count)
			_call_number = "%s" % [count];
		elif current_beat_int%2 == 0:
			@warning_ignore("integer_division")
			var count:int = (current_beat_int%8) / 2 + 1
			count_off.emit(count)
			_call_number = "%s" % [count];
		elif current_beat_int%4 == 3:
			countdown_fast = true;
		#print("call: %s		current_beat: %s-%s-%s" % [_call_number, current_beat_int+1,(current_beat_int%4)+1,(current_beat_int%16)+1])


func play_with_check():
	var current_beat_int:int = floor(current_beat)
	var last_beat_int:int =floor(last_time*2.0)
	if current_beat_int != last_beat_int:
		deck_beats[0] += 1
		deck_beats[1] += 1
		#print("current_beat: %s-%s-%s		deck_one: %s		deck_two: %s" % [current_beat_int+1,(current_beat_int%4)+1,(current_beat_int%16)+1,deck_beats[0],deck_beats[1]])
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
					
		if deck_beats[0] == deck_beats[1] and synced == false:
			synced = true
			beats_synced.emit(true)
		elif deck_beats[0]!= deck_beats[1] and synced == true:
			synced = false
			beats_synced.emit(false)
		beat.emit(current_beat_int+1,(current_beat_int%4)+1,(current_beat_int%16)+1 )

signal beats_synced(synced:bool)

func play(deck_id:int = -1):
	if deck_id == -1:
		decks[0].play(.01)
		decks[1].play(.01)
	elif deck_id ==0 or deck_id == 1:
		decks[deck_id].play(.01)
	playing = true

	GameStateController.start_wave();

func stop():
	playing = false
	decks[0].stop()
	decks[1].stop()

func reset_music():
	countdown_fast = false;
	playing = false
	countdown = false 
	current_time = -1.0 # -1 because we add one before determining which beat 
	last_time = 0.0
	deck_beats[0] = -1 # -1 because we add one before determining which beat 
	deck_beats[1] = -1 # -1 because we add one before determining which beat 
	decks[0].stop()
	decks[1].stop()
	
func load_track(deck_id:int =0, track_id:int = 0):
	if deck_id == 0:
		decks[deck_id].stream = drum_n_bass_tracks[track_id]
		drum_attack_changed.emit(track_id)
		playing_drum_attack = track_id as drum_attacks
	else:
		decks[deck_id].stream = lead_tracks[track_id]
		lead_attack_changed.emit(track_id)
		playing_lead_attack = track_id as lead_attacks
		
func stop_background_music():
	$MusicController.stop()

func start_background_music():
	$MusicController.play()

signal sample_triggered(damage_info:DamageInfo)
enum sample_attacks {STANDARD, SLOW, AOE, DOT, PIERCE, MULTI, FAST}

func sample_attack(damage_info:DamageInfo,button:SampleBox):
	var accuracy:float = abs(current_beat - round(current_beat))
	#print("Accuracy: %s = %s - %s" % [accuracy, current_beat, round(current_beat)])
	var accuracy_text:String = ""
	var damage_mod: float = 1.0
	if accuracy < .15: # within 1 frame
		accuracy_text = "Perfect!"
		damage_mod = 2.0
	elif accuracy < .30: # within 2 frames
		accuracy_text = "Great!"
		damage_mod = 1.5
	elif accuracy < .60: # within 4 frame 
		accuracy_text = "Not Bad!"
		damage_mod = 1.2
	else:
		accuracy_text = "Meh"
	button.return_accuracy(accuracy_text)
	sample_triggered.emit(damage_info, damage_mod)
