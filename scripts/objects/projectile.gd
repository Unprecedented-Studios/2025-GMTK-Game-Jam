extends Sprite2D
@export var speed: float = 400;
@export var damage: int = 5;


func _physics_process(delta):
	global_position += Vector2(0, -speed * delta);


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage);
			queue_free();
