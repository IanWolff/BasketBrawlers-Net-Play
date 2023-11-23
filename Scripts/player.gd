extends CharacterBody2D
class_name Player

@export_category("Player Properties")
@export var move_speed : float = 400.0
@export var throw_strength : float = 35.0
@export var jump_force : float = 1000.0
@export var gravity : float = 16.0
@export var max_jump_count : int = 2

@export_category("Player States")
@export var is_grounded : bool = false
@export var is_short_hopping : bool = false
@export var is_jumping : bool = false
@export var is_holding_object : bool = false
@export var can_move : bool = true

# Player graphics
@onready var player_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var particle_trails : CPUParticles2D = $ParticleTrails
@onready var death_particles : CPUParticles2D = $DeathParticles

var jump_count : int = 2
var was_on_floor : bool = false
var throw_velocity : Vector2 = Vector2.ZERO
var forward_vector : Vector2 = Vector2.RIGHT

var grabbable_objects : Array[Ball] = []
var held_object


func _process(_delta):
	movement()
	player_animations()
	flip_player()

# Player Movement Code
func movement():
	# Apply gravity to Player
	if !is_on_floor():
		if is_holding_object:
			velocity.y += 0.1 * gravity
		else:
			velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	# Handle jumping and set variables for coyote time
	handle_actions()
	handle_timers()
	was_on_floor = is_on_floor()
	# Move Player
	if can_move:	
		var inputAxis = Input.get_axis("Left", "Right")
		velocity = Vector2(inputAxis * move_speed, velocity.y)
		move_and_slide()
	if was_on_floor and !is_on_floor():
		$CoyoteTimer.start()

func handle_timers():
	if $GrabComponent/ThrowTimer.is_stopped() and is_holding_object:
		throw(throw_velocity * throw_strength)
	if $ShortHopTimer.is_stopped() and is_short_hopping:
		stop_jump()

# Handles jumping functionality
func handle_actions():
	if Input.is_action_just_pressed("Jump") and can_move:
		if (is_on_floor() or !$CoyoteTimer.is_stopped()):
			jump()
	elif Input.is_action_just_pressed("Grab-Drop"):
		if is_holding_object:
			initiate_throw()
			$GrabComponent/ThrowTimer.stop()
		else:
			grab()
	if Input.is_action_just_released("Jump") and !$ShortHopTimer.is_stopped() and can_move:
		is_short_hopping = true
	# Reset player jump states
	if is_on_floor():
		is_jumping = false
		is_short_hopping = false
	
# Player jump
func jump():
	is_jumping = true
	velocity.y = -jump_force
	$ShortHopTimer.start()
	jump_tween()
	#AudioManager.jump_sfx.play()

# Drops the currently held object
func grab():
	if len(grabbable_objects) > 0:
		held_object = grabbable_objects.pop_front()
		held_object.grab(self)
		$GrabComponent/ThrowTimer.start()
		# Handle states
		is_holding_object = true
		can_move = false

# Drops the currently held object
func drop_held_object():
	held_object.reparent(self.get_parent())
	held_object.drop(velocity)
	held_object = null
	is_holding_object = false

func initiate_throw():
	if Input.is_action_pressed("Up"):
		throw_velocity = Vector2.UP
	elif Input.is_action_pressed("Down"):
		throw_velocity = Vector2.DOWN
	elif Input.is_action_pressed("Left"):
		throw_velocity = Vector2.LEFT
	elif Input.is_action_pressed("Right"):
		throw_velocity = Vector2.RIGHT
	else:
		throw_velocity = forward_vector

# Drops the currently held object
func throw(ball_velocity : Vector2):
	held_object.reparent(self.get_parent())
	held_object.drop(throw_strength * ball_velocity)
	held_object = null
	throw_velocity = Vector2.ZERO
	# Handle states
	is_holding_object = false
	can_move = true
	
# Short hop
func stop_jump():
	if velocity.y < -100:
		velocity.y = -100	

# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	if is_on_floor():
		if abs(velocity.x) > 0:
			particle_trails.emitting = true
			player_sprite.play("Walk", 1.5)
		else:
			player_sprite.play("Idle")
	else:
		player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		forward_vector = Vector2.LEFT
		player_sprite.flip_h = true
	elif velocity.x > 0:
		forward_vector = Vector2.RIGHT
		player_sprite.flip_h = false

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_grab_component_area_entered(area):
	if area.name == "GrabComponent":
		grabbable_objects.append(area.get_parent())

func _on_grab_component_area_exited(area):
	if area.name == "GrabComponent":
		grabbable_objects.erase(area.get_parent())
