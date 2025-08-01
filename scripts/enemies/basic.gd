extends CharacterBody2D
@export var speed: float = 200;
@export var health: float = 30;
@export var damage: int = 10;

@onready var health_bar = %HealthProgress
@onready var current_speed = speed;

signal dying(CharacterBody2D)

var _dotDamage:float = 0;
var _score:int = 0

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;
	_score = health / 10
	Looper.beat.connect(_on_beat)

func _physics_process(_delta):
	velocity = Vector2(-current_speed, 0);
	move_and_slide()
	
	var collision_count = get_slide_collision_count();
	for i in collision_count:
		var collision_info = get_slide_collision(i);
		var collider = collision_info.get_collider();
		if (collider.has_method("take_damage") && collider.is_in_group("player")):
			var damage_info = DamageInfo.new()
			damage_info.damage = damage
			collider.take_damage(damage_info)
			_die()

func take_damage(info: DamageInfo):
	$HitParticles.emitting = true
	if (info.effects.has(DamageInfo.effect_types.DOT)):
		_dotDamage += info.damage;
		$BloodParticles.emitting= true
	else:
		health -= info.damage;	
		health_bar.value = health;
		if (health <= 0):
			GameStateController.score_enemy(score)
			_die()

	if (info.effects.has(DamageInfo.effect_types.SLOW)):
		current_speed = speed / 2
		modulate = Color.CORNFLOWER_BLUE

var score: int:
	get: 
		return _score;
		
func _on_beat(_beat_counter,_note, _count):
	if _dotDamage > 0:
		var damageInfo = DamageInfo.new()
		damageInfo.type = DamageInfo.damage_types.POISON
		damageInfo.damage = _dotDamage
		take_damage(damageInfo);

func _die():
	dying.emit(self);
	queue_free();
