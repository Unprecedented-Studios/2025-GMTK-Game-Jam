extends Control
class_name DJDeck


var looper:Loops = Looper
@onready var rings:Array[TextureProgressBar] = [$Vbox/HBoxContainer/DrumNBassRing, $Vbox/HBoxContainer/LeadsRing]
@onready var drum_n_bass_track_buttons:Array[Button] = \
[$Vbox/HBoxContainer/DrumNBassTracks/Track1,
$Vbox/HBoxContainer/DrumNBassTracks/Track2,
$Vbox/HBoxContainer/DrumNBassTracks/Track3,
$Vbox/HBoxContainer/DrumNBassTracks/Track4]
@onready var lead_track_buttons:Array[Button] = \
[$Vbox/HBoxContainer/LeadTracks/Track1,
$Vbox/HBoxContainer/LeadTracks/Track2,
$Vbox/HBoxContainer/LeadTracks/Track3,
$Vbox/HBoxContainer/LeadTracks/Track4]
@onready var track_buttons:Array[Array] = [drum_n_bass_track_buttons,lead_track_buttons]
enum states {STOPPING, PLAYING, QUEUED, STOPPED}
var track_button_states:Array[Array] = [
	[states.PLAYING, states.STOPPED, states.STOPPED, states.STOPPED]
,[states.PLAYING, states.STOPPED, states.STOPPED, states.STOPPED]]

var track_icon = preload("res://assets/icons/track_icon.png")
var track_playing_icon = preload("res://assets/icons/track_playing_icon.png")
var track_queued_icon =  preload("res://assets/icons/track_queued_icon.png")
var track_stopping_icon =  preload("res://assets/icons/track_stopping_icon.png")


func _process(_delta: float) -> void:
	for deck in 2:
		rings[deck].value = looper.deck_beats[deck]
		if looper.deck_beats[deck] == 0:
			for i in track_button_states[deck].size():
				if track_button_states[deck][i] == states.STOPPING:
					track_buttons[deck][i].icon = track_icon
					track_button_states[deck][i] = states.STOPPED
				elif track_button_states[deck][i] == states.QUEUED:
					track_buttons[deck][i].icon = track_playing_icon
					track_button_states[deck][i] = states.PLAYING
					
	joystick_input()

func _on_track_button_up(deck:int, track: int) -> void:
	looper.deck_queued[deck] = true
	looper.deck_queued_track[deck] = track
	var queued_track_button:Button = track_buttons[deck][track] 

	for i in track_button_states[deck].size():
		if track_button_states[deck][i] == states.PLAYING or track_button_states[deck][i] == states.STOPPING:
			track_buttons[deck][i].icon = track_stopping_icon
			track_button_states[deck][i] = states.STOPPING
		#make sure to clear any other buttons that were queued
		elif track_button_states[deck][i] == states.QUEUED: 
			track_buttons[deck][i].icon = track_icon
			track_button_states[deck][i] = states.STOPPED
	track_button_states[deck][track] = states.QUEUED
	queued_track_button.icon = track_queued_icon
	
	
	
func joystick_input():
	var axis1 = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	var axis2 = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var axis3 = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	var axis4 = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	if axis1 > .5:
		_on_track_button_up(0, 2)
	elif axis1 < -.5:
		_on_track_button_up(0, 0)
	elif axis2 > .5:
		_on_track_button_up(0, 1)
	elif axis2 < -.5:
		_on_track_button_up(0, 3)
	if axis3 > .5:
		_on_track_button_up(1, 2)
	elif axis3 < -.5:
		_on_track_button_up(1, 0)
	elif axis4 > .5:
		_on_track_button_up(1, 1)
	elif axis4 < -.5:
		_on_track_button_up(1, 3)
		
func _input(_event: InputEvent) -> void:
	if _event.is_action_released("drum_track_1"):
		_on_track_button_up(0, 0)
	elif _event.is_action_released("drum_track_2"):
		_on_track_button_up(0, 1)
	elif _event.is_action_released("drum_track_3"):
		_on_track_button_up(0, 2)
	elif _event.is_action_released("drum_track_4"):
		_on_track_button_up(0, 3)
	elif _event.is_action_released("lead_track_1"):
		_on_track_button_up(1, 0)
	elif _event.is_action_released("lead_track_2"):
		_on_track_button_up(1, 1)
	elif _event.is_action_released("lead_track_3"):
		_on_track_button_up(1, 2)
	elif _event.is_action_released("lead_track_4"):
		_on_track_button_up(1, 3)
