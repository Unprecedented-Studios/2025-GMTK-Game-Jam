extends Area2D
@onready var explosion = %Explosion

var damageInfo:DamageInfo = DamageInfo.new();

func _ready():
	explosion.play()

func _on_explosion_animation_finished():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damageInfo);
