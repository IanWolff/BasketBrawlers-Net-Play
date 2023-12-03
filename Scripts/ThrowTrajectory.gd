extends Line2D

var max_points: int = 300
var point_coordinate: Vector2 = Vector2.ZERO
var parent_holder
var gravity: float = 2000.0
var friction: float = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_holder = self.get_parent()
	position.x = 0
	position.y = -38

func _physics_process(delta):
	pass

func update_trajectory(direction: Vector2, throw_speed: float, gravity: float, delta: float):
	self.reparent(parent_holder)
	clear_points()
	point_coordinate = Vector2.ZERO
	var projected_velocity = direction * throw_speed
	for point in max_points:
		add_point(point_coordinate)
		
		var collision_info = $CollisionTest.move_and_collide(projected_velocity * delta, false, true, true)
		if collision_info:
			projected_velocity = projected_velocity.bounce(collision_info.get_normal())
			if projected_velocity.x > 0:
				projected_velocity.x -= friction * delta
			elif projected_velocity.x < 0:
				projected_velocity.x += friction * delta
			projected_velocity.y += gravity * delta
		point_coordinate += projected_velocity * delta
		projected_velocity.y += gravity * delta
		$CollisionTest.position = point_coordinate
		position.x = 0
		position.y = -38
	self.reparent(self.get_parent().get_parent())
