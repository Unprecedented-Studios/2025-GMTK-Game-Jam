extends TextureRect
class_name Background

func _ready() -> void:
	Looper.beat.connect(_on_beat)


var colors:Array[Color] = \
[Color.BLUE, Color.RED, Color.GREEN, Color.ORANGE, Color.YELLOW, Color.INDIGO, Color.VIOLET,
Color.CADET_BLUE, Color.DARK_VIOLET, Color.FOREST_GREEN, Color.LIGHT_PINK]

func _on_beat(_beat:int, _measure_beat:int, _loop_beat:int) -> void:
	if Looper.flashy:
		self_modulate = colors[randi_range(0,colors.size()-1)]
