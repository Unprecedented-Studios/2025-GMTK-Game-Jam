extends Sprite2D
@export var speed: float = 400;

func _physics_process(delta):
	global_position += Vector2(0, -speed * delta);


func _on_area_2d_body_entered(body):
	print("hit")
