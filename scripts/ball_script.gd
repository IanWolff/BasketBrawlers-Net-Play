extends CharacterBody2D

@export_category("Ball Properties") # You can tweak these changes according to your likings
@export var gravity: float = 2000
@export var friction: float = 30
@export var bounce_power: float = 1.5
@export var minimum_speed: float = 100.0
@export var minimum_height_gain: float = 100
@export var max_speed: float = 400.0

@export_category("Toggle Functions")
@export var has_gravity : bool = true
@export var has_friction : bool = true
@export var can_move : bool = true
@export var can_be_grabbed : bool = true
@export var is_held : bool = false

@export_category("Ball Values") # You can tweak these changes according to your likings
@export var speed: float = 0.0

var rand : RandomNumberGenerator = RandomNumberGenerator.new()

# Ball States
var is_grabbable : bool = false

func _ready():
	reset()

func reset():
	is_grabbable = true
	position.x = 0
	position.y = -28
	velocity.y = rand.randf_range(-1500,-500)
	velocity.x = rand.randf_range(-500,500)

func _physics_process(delta):
	if can_move:
		speed = velocity.length()
		var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
			if velocity.x > 0:
				velocity.x -= friction * delta
			elif velocity.x < 0:
				velocity.x += friction * delta
			else:
				velocity.x += rand.randf_range(-5,5)
		if has_gravity:
			velocity.y += gravity * delta
	#if can_be_grabbed:
	#	$GrabComponent.show()
	#else:
	#	$GrabComponent.hide()

func disable():
	is_grabbable = false

func enable():
	is_grabbable = true

func grab(grabbing_player):
	self.reparent(grabbing_player)
	can_move = false
	is_held = true
	position.x = 0
	position.y = -38
	scale.x = 1
	scale.y = 1

func drop(thrower_velocity : Vector2):
	if is_held:
		can_move = true
		velocity = thrower_velocity
		scale.x = 1
		scale.y = 1
