extends CharacterBody2D
class_name Player

@export_category("Player Properties")
@export var move_speed : float = 400.0
@export var jump_force : float = 1000.0
@export var gravity : float = 16.0
@export var max_jump_count : int = 2

@export_category("Toggle Functions")
@export var double_jump : bool = false

@export_category("Player States")
@export var is_grounded : bool = false
@export var is_short_hopping : bool = false
@export var is_jumping : bool = false

# Player graphics
@onready var player_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var particle_trails : CPUParticles2D = $ParticleTrails
@onready var death_particles : CPUParticles2D = $DeathParticles

# Timers
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var short_hop_timer: Timer = $ShortHopTimer

var jump_count : int = 2
var was_on_floor : bool = false
var overlapping_bodies : Array[RigidBody2D] = []

func _process(_delta):
	movement()
	player_animations()
	flip_player()

# Player Movement Code
func movement():
	# Apply gravity to Player
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	# Handle jumping and set variables for coyote time
	handle_jumping()
	was_on_floor = is_on_floor()
	
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("Jump"):
		if (is_on_floor() or !coyote_timer.is_stopped()) and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1
	if Input.is_action_just_released("Jump") and !short_hop_timer.is_stopped():
		is_short_hopping = true
	if short_hop_timer.is_stopped() and is_short_hopping:
		stop_jump()
	if is_on_floor():
		is_jumping = false
		is_short_hopping = false
		
# Player jump
func jump():
	is_jumping = true
	short_hop_timer.start()
	jump_tween()
	#AudioManager.jump_sfx.play()
	velocity.y = -jump_force

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
		player_sprite.flip_h = true
	elif velocity.x > 0:
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

