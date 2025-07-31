extends Sprite2D
@export var speed: float = 400;
@export var damage: int = 5;
@export var sync_bonus = 1.2
var _damage_info: DamageInfo = DamageInfo.new()
var _explode: bool = false;
var _pierce: bool = false;
var _hitEnemy: Dictionary = {}

func _ready():
	
	match Looper.playing_lead_attack:
		Looper.lead_attacks.FAST:
			damage /= 5
		Looper.lead_attacks.PIERCE:
			damage -= 1
			_pierce = true;
		Looper.lead_attacks.MULTI:
			damage /= 4
	
	match Looper.playing_drum_attack:
		Looper.drum_attacks.SLOW:
			_damage_info.effects.push_back(DamageInfo.effect_types.SLOW);
			modulate.r = 0
		Looper.drum_attacks.DOT:
			_damage_info.effects.push_back(DamageInfo.effect_types.DOT);
			modulate.g = 0
		Looper.drum_attacks.AOE:
			_explode = true;
			modulate.g = 0.5;
			modulate.b = 0;
	
	var multiplier = 1;
	if (Looper.synced):
		multiplier *= sync_bonus;
		
	_damage_info.damage = damage * multiplier;
	scale *= max(1, _damage_info.damage*.25)

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0);

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			if (!_pierce):
				body.take_damage(_damage_info);
				queue_free();
			else:
				if _hitEnemy.has(body):
					return;
				body.take_damage(_damage_info);
				_hitEnemy.set(body, true)
				_damage_info.damage -= 1;
				scale *= max(1, _damage_info.damage*.25)
				if (_damage_info.damage <= 0):
					queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
