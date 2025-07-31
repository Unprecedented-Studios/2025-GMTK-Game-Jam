extends Sprite2D
@export var speed: float = 400;
@export var damage: int = 1;

var _damage_info: DamageInfo = DamageInfo.new()

func _ready():
	_damage_info.damage = damage;

func _physics_process(delta):
	global_position += Vector2(speed * delta, 0);

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(_damage_info);
			queue_free();
