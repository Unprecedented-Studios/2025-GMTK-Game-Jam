extends HBoxContainer
class_name  SampleBox


var sample_preloads:Dictionary = {\
	"Noise_Sweep":preload("res://assets/samples/Noise_Sweep_1.mp3"),
	"Big_Explosion":preload("res://assets/samples/Big_Explosion.mp3"),
	"Glitches":preload("res://assets/samples/Glitches.mp3"),
	"Growl":preload("res://assets/samples/Growl.mp3"),
	"Record_Scratch":preload("res://assets/samples/Record_Scratch.mp3")
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
		$AudioStreamPlayer.stream = new_stream 
		set_text(new_sample_name)


var drop_amount:float = 0.0
func _process(delta: float) -> void:
	if $TextureProgressBar.value > 0.0:
		drop_amount += 100 * (delta/cooldown)
		if drop_amount >= .01:
			$TextureProgressBar.value -= drop_amount
			drop_amount = 0.0
	elif $SampleButton.disabled:
		$SampleButton.disabled = false

func set_text(new_text:String = "Sample"): 
	$SampleButton.text = registered_key + " - " + new_text

func play_sound():
	Looper.sample_attack(damage_info)
	_on_sample_button_down()


func _on_sample_button_down() -> void:
	$AudioStreamPlayer.play()
	$TextureProgressBar.value = 100.0
	$SampleButton.disabled = true
	
func _input(event: InputEvent) -> void:
	if not $SampleButton.disabled:
		if event.is_action_pressed("sample_1") and registered_key == "Q":
			play_sound()
		if event.is_action_pressed("sample_2") and registered_key == "W":
			play_sound()
		if event.is_action_pressed("sample_3") and registered_key == "E":
			play_sound()
		if event.is_action_pressed("sample_4") and registered_key == "R":
			play_sound()
		
		
