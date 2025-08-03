extends Control
class_name  SampleBox


var sample_preloads:Dictionary = {\
	"Sweep":preload("res://assets/samples/Noise_Sweep_1.mp3"),
	"Explosion":preload("res://assets/samples/Big_Explosion.mp3"),
	"Glitches":preload("res://assets/samples/Glitches.mp3"),
	"Growl":preload("res://assets/samples/Growl.mp3"),
	"Scratch":preload("res://assets/samples/Record_Scratch.mp3")
	}

enum damage_types {
	NORMAL,
	ELECTRIC,
	AIR,
	WATER,
	FIRE,
	EARTH,
	ICE,
	POISON
}

enum effect_types {
	SLOW,
	PIERCE,
	DOT
}

#damage, type, effects
var damage_info:DamageInfo = DamageInfo.new()

@export var registered_key:String = "Q"

@export var type:DamageInfo.damage_types:
	set(new_value):
		damage_info.type = new_value
	get:
		return damage_info.type
		
@export var effect:Array[DamageInfo.effect_types]:
	set(new_value):
		damage_info.effects = new_value
	get:
		return damage_info.effects
			
@export var damage_amount:float:
	set(new_value):
		damage_info.damage = new_value
	get:
		return damage_info.damage
		
@export var cooldown:float = 8.0

@export var sample_name:String:
	set(new_sample_name):
		var new_stream:AudioStreamMP3 = AudioStreamMP3.new()
		new_stream = sample_preloads[new_sample_name]
		$Hbox/AudioStreamPlayer.stream = new_stream 
		set_text(new_sample_name)



var drop_amount:float = 0.0
func _process(delta: float) -> void:
	if $Hbox/TextureProgressBar.value > 0.0:
		drop_amount += 100 * (delta/cooldown)
		if drop_amount >= .01:
			$Hbox/TextureProgressBar.value -= drop_amount
			drop_amount = 0.0
	elif $Hbox/SampleButton.disabled:
		$Hbox/SampleButton.disabled = false

func set_text(new_text:String = "Sample"): 
	var explainer_text:String = ""
	
	for i in damage_info.effects.size():
		if damage_info.effects[i] == effect_types.SLOW:
			explainer_text += "Slows "
		elif damage_info.effects[i] == effect_types.PIERCE:
			explainer_text += "Pierces "
		elif damage_info.effects[i] == effect_types.DOT:
			explainer_text += "DOTs "
		if i < damage_info.effects.size()-1:
			explainer_text += "and "
	
	explainer_text += "Enemies"
	$Hbox/SampleButton.text = registered_key + " - " + new_text + "\n"\
	+ explainer_text

func play_sound():
	_on_sample_button_down()


func _on_sample_button_down() -> void:
	if Looper.playing:
		$Hbox/AudioStreamPlayer.play()
		$Hbox/TextureProgressBar.value = 100.0
		$Hbox/SampleButton.disabled = true
		Looper.sample_attack(damage_info,self)

signal display_accuracy(text:String)
func return_accuracy(text:String):
	display_accuracy.emit(text)
	
func _input(event: InputEvent) -> void:
	if not $Hbox/SampleButton.disabled:
		if event.is_action_pressed("sample_1") and registered_key == "Q":
			play_sound()
		if event.is_action_pressed("sample_2") and registered_key == "W":
			play_sound()
		if event.is_action_pressed("sample_3") and registered_key == "E":
			play_sound()
		if event.is_action_pressed("sample_4") and registered_key == "R":
			play_sound()
		
		
