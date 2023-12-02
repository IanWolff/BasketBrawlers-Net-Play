extends State
class_name PlayerState

@export var Player : CharacterBody2D

@export_category("Physics")
@export var gravity : float = 16.0

@export_category("Properties")
@export var move_speed : float = 700.0
@export var toss_strength : float = 700.0
@export var throw_strength : float = 1200.0
@export var jump_strength : float = 1000.0
@export var max_jump_count : int = 2

@export_category("States")
@export var is_grounded : bool = false
@export var is_short_hopping : bool = false
@export var is_jumping : bool = false
@export var is_holding_object : bool = false

@export_category("Permissions")
@export var can_move : bool = true
@export var can_action : bool = true
@export var can_grab: bool = true

# Player graphics
@onready var player_sprite : AnimatedSprite2D = $AnimatedSprite2D2

func Enter():
	pass

func Update(_delta):
	pass

func _process(_delta):
	movement()
	player_animations()
	flip_player()

func movement():
	pass

func handle_timers():
	pass

func handle_actions():
	pass

func player_animations():
	pass

func flip_player():
	pass
