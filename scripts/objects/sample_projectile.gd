extends Sprite2D
class_name SampleProjectile

@export var speed: float = 500;
@export var damage: float = 5;
var _damage_info: DamageInfo = DamageInfo.new()
var _explode: bool = false;
var _pierce: bool = false;

const EXPLOSION_SCENE = preload("res://scenes/projectiles/explosion.tscn")

func set_damage_info(di:DamageInfo):
	_damage_info = di
	if _damage_info.effect_types.find_key(DamageInfo.effect_types.PIERCE):
		_pierce = true
	damage = _damage_info.damage
	


func _physics_process(delta):
	global_position += Vector2(speed * delta, 0);

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			_do_damage(body)
			if (!_pierce):
				queue_free();
			else:
				_damage_info.damage -= 1;
				if (_damage_info.damage <= 0):
					queue_free()

func _do_damage(body):
	if _explode:
		var explosion = EXPLOSION_SCENE.instantiate();
		explosion.position = position;
		explosion.damageInfo = _damage_info;
		get_parent().call_deferred("add_child",explosion);
	else:
		body.take_damage(_damage_info);

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
