extends Sprite2D
@export var speed: float = 400;
@export var damage: int = 1;

var _damage_info: DamageInfo = DamageInfo.new()

func _ready():
	_damage_info.damage = damage;
	if (Looper.playing_drum_attack == Looper.drum_attacks.SLOW):
		_damage_info.effects.push_back(DamageInfo.effect_types.SLOW);
		modulate.r = 0

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0);

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(_damage_info);
			queue_free();
