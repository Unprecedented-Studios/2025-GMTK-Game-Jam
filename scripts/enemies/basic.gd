extends CharacterBody2D
@export var speed: float = 200;
@export var health: int = 10;
@export var damage: int = 10;

@onready var health_bar = %HealthProgress

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;

func _physics_process(delta):
	velocity = Vector2(0, speed);
	move_and_slide()
	
	var collision_count = get_slide_collision_count();
	for i in collision_count:
		var collision_info = get_slide_collision(i);
		var collider = collision_info.get_collider();
		if (collider.has_method("take_damage")):
			collider.take_damage(damage)
			queue_free()

func take_damage(amount):
	health -= amount;
	health_bar.value = health;
	if (health <= 0):
		queue_free();
