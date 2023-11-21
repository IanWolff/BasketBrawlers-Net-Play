extends CharacterBody2D
class_name Ball

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

@export_category("Ball Values") # You can tweak these changes according to your likings
@export var speed: float = 0.0

var rand : RandomNumberGenerator = RandomNumberGenerator.new()

# Ball States
var is_grabbable : bool = false
var grab_candidates : Array[Player] = []

func _ready():
	velocity.y = rand.randf_range(-1500,-500)
	velocity.x = rand.randf_range(-500,500)

func _physics_process(delta):
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

func grab(grabbing_player : Player) -> bool:
	if is_grabbable && grab_candidates.has(grabbing_player):
		print("You grabbed it!")
		return true
	return false

func _on_grab_component_area_entered(area):
	if area is GrabComponent:
		grab_candidates.append(area.get_parent())
		is_grabbable = true

func _on_grab_component_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area is GrabComponent:
		grab_candidates.erase(area.get_parent())
		is_grabbable = len(grab_candidates) > 0
