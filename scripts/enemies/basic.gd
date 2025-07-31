extends CharacterBody2D
@export var speed: float = 200;
@export var health: float = 10;
@export var damage: int = 10;

@onready var health_bar = %HealthProgress

@onready var current_speed = speed;

func _ready():
	health_bar.max_value = health;
	health_bar.value = health;

func _physics_process(_delta):
	velocity = Vector2(-current_speed, 0);
	move_and_slide()
	
	var collision_count = get_slide_collision_count();
	for i in collision_count:
		var collision_info = get_slide_collision(i);
		var collider = collision_info.get_collider();
		if (collider.has_method("take_damage") && !collider.is_in_group("enemy")):
			var damage_info = DamageInfo.new()
			damage_info.damage = damage
			collider.take_damage(damage_info)
			queue_free()

func take_damage(info: DamageInfo):
	health -= info.damage;
	health_bar.value = health;
	if (health <= 0):
		queue_free();
	
	if (info.effects.has(DamageInfo.effect_types.SLOW)):
		current_speed = speed / 2
