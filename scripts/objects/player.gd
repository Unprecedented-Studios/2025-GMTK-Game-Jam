extends StaticBody2D
@export var health:float = 500

@onready var health_bar = %Healthbar
@onready var wave_number_label = %WaveNumberLabel
@onready var score_number_label = %ScoreNumberLabel

var game_state:GameState

signal died

func _ready():
	game_state = GameState.get_or_create_state()
		
	health_bar.max_value = health;
	if game_state.playerData.has("health"):
		health = game_state.playerData.health
		score_number_label.text = "%s" % game_state.playerData.score
		wave_number_label.text = "%s" % [game_state.playerData.lastWave + 1]
	
	health_bar.value = health;
	GameStateController.started.connect(_wave_started)
	GameStateController.scoreChange.connect(_score_changed)
	GameStateController.complete.connect(_wave_completed)

func take_damage(info: DamageInfo):
	health -= info.damage;
	health_bar.value = health;
	if (health <= 0):
		game_state.playerData = {}
		GlobalState.save()
		died.emit();
		#queue_free();

func _wave_started(waveID:int):
	wave_number_label.text = "%s" % waveID

func _wave_completed(waveID:int):
	game_state.playerData.lastWave = waveID
	game_state.playerData.health = health
	game_state.playerData.score = GameStateController.score
	GlobalState.save()

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
		if Looper.flashy:
			var color_amount:float = .9 + bounce*.1
			$Booth.modulate = Color(color_amount,color_amount,color_amount,1)
