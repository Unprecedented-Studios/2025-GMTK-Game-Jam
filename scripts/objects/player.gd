extends StaticBody2D
@export var health:float = 500

@onready var health_bar = %Healthbar
@onready var wave_number_label = %WaveNumberLabel
@onready var score_number_label = %ScoreNumberLabel

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;
	GameStateController.started.connect(_wave_started)
	GameStateController.scoreChange.connect(_score_changed)

func take_damage(info: DamageInfo):
	health -= info.damage;
	health_bar.value = health;
	#if (health <= 0):
		#queue_free();

func _wave_started():
	wave_number_label.text = "%s" % GameStateController.waveCount

func _score_changed(score):
	score_number_label.text = "%s" % score

func _process(delta: float) -> void:
	if Looper.playing:
		var bounce:float = pow(cos((Looper.current_beat*3)),4) *3
		$LeftArm.scale.x = 1.149 + cos(Looper.current_beat*8)*.1
		$RightArm.scale.x = 1.149 + sin(Looper.current_beat*8)*.1
		$Player.position.y = -171.0 + bounce
		$LeftArm.position.y = -34.0 + bounce
		$RightArm.position.y = 6.0 + bounce
		$LeftRecordPivot.rotation += delta * 4.0
		$RightRecordPivot.rotation += delta * 4.0
