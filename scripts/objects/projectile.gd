extends Sprite2D
@export var speed: float = 400;
@export var damage: int = 5;

var _damage_info: DamageInfo = DamageInfo.new()

func _ready():
	if (Looper.playing_lead_attack == Looper.lead_attacks.FAST):
		damage /= 5
		
	if (Looper.playing_drum_attack == Looper.drum_attacks.SLOW):
		_damage_info.effects.push_back(DamageInfo.effect_types.SLOW);
		modulate.r = 0

	_damage_info.damage = damage;

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0);

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(_damage_info);
			queue_free();

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
