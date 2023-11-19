extends CharacterBody2D

var velocity_vector: Vector2 = Vector2.ZERO
var remainder: float = 0.0

func _physics_process()
	var collision: = move_and_collide(velocity * delta + velocity.normalized()*remainder)
	remainder = 0.0
	if coll:
		var speed: = velocity.length() 							#current speed
		var dir: = velocity.normalized()						#current direction
		var normal:Vector2 = collision.normal
		remainder = collision.remainder.length()				#velocity remainder
		velocity = dir.bounce(normal) *speed					#velocity after bouncing off the surface
