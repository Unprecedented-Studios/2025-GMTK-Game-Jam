extends HBoxContainer
class_name  SampleBox

enum sample_effect {damage}
var sample_preloads:Dictionary = {\
	"Noise_Sweep_1":preload("res://assets/samples/Noise_Sweep_1.mp3")}
	
@export var registered_key:String = "Q"
var cooldown:float = 8.0
var drop_amount:float = 0.0
signal sample_play
@export var sample_name:String:
	set(new_sample_name):
		var new_stream:AudioStreamMP3 = AudioStreamMP3.new()
		new_stream = sample_preloads[new_sample_name]
		$AudioStreamPlayer.stream = new_stream 
		set_text(new_sample_name)

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
	sample_play.emit()
	_on_sample_button_down()


func _on_sample_button_down() -> void:
	$AudioStreamPlayer.play()
	$TextureProgressBar.value = 100.0
	$SampleButton.disabled = true
	
func _input(event: InputEvent) -> void:
	if not $SampleButton.disabled:
		if event.is_action_pressed("sample_1") and registered_key == "Q":
			_on_sample_button_down()
		if event.is_action_pressed("sample_2") and registered_key == "W":
			_on_sample_button_down()
		if event.is_action_pressed("sample_3") and registered_key == "E":
			_on_sample_button_down()
		if event.is_action_pressed("sample_4") and registered_key == "R":
			_on_sample_button_down()
		
		
