extends CharacterBody2D

@export_category("Ball Properties") # You can tweak these changes according to your likings
@export var gravity: float = 2000.0
@export var friction: float = 30
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

var last_owner : Autoload.player_side = Autoload.player_side.NONE
var rand : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	reset()

func reset():
	$Collision.hide()
	set_last_owner(Autoload.player_side.NONE)
	can_be_grabbed = true
	position.x = 0
	position.y = -28
	velocity.y = rand.randf_range(-1500,-1000)
	velocity.x = rand.randf_range(-50,00)

func _physics_process(delta):
	if can_move:
		speed = velocity.length()
		var collision_info : KinematicCollision2D = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
			#velocity.x += rand.randf_range(-5,5)
			if velocity.x > 0:
				velocity.x -= friction * delta
			elif velocity.x < 0:
				velocity.x += friction * delta
			#else:
				#velocity.x += rand.randf_range(-5,5)
		if has_gravity:
			velocity.y += gravity * delta
	#if can_be_grabbed:
	#	$GrabComponent.show()
	#else:
	#	$GrabComponent.hide()

func is_grabbable() -> bool:
	return can_be_grabbed

func disable():
	can_be_grabbed = false

func enable():
	can_be_grabbed = true

func grab(grabbing_player):
	self.reparent(grabbing_player)
	can_move = false
	is_held = true
	position.x = 0
	position.y = -38
	scale.x = 1
	scale.y = 1

func set_last_owner(new_owner : Autoload.player_side):
	last_owner = new_owner
	self.modulate = Autoload.get_player_color(new_owner)

func get_last_owner():
	return last_owner

func drop(thrower_velocity : Vector2):
	if is_held:
		can_move = true
		velocity = thrower_velocity
		scale.x = 1
		scale.y = 1
