extends CharacterBody2D

@export var gravity: float = 1500
@export var bounce_power: float = 1.5
@export var minimum_speed: float = 100.0
@export var minimum_height_gain: float = 100
@export var max_speed: float = 600.0

func _ready():
	set_velocity(Vector2(250, 250))

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) 
	velocity.y += gravity * delta
			
