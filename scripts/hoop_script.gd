extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var color_keep
var is_scorable : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$ScoreArea.hide()

func _physics_process(delta):
	pass


func _on_trigger_area_area_entered(area):
	if area.get_parent().name == "Ball":
		print("Ball entered")
		color_keep = $TriggerArea.modulate
		$TriggerArea.modulate = Color.RED
		is_scorable = true
		$ScoreArea.show()


func _on_trigger_area_area_exited(area):
	if area.get_parent().name == "Ball":
		$TriggerArea.modulate = color_keep
		is_scorable = false
		$ScoreArea.hide()


func _on_score_area_area_entered(area):
	if area.get_parent().name == "Ball" and is_scorable:
		is_scorable = false
		print ("Scored")
