extends StaticBody2D

const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0

var color_keep : Color
var is_scorable : bool = false
var score : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 0 # ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$ScoreArea.hide()

func _physics_process(delta):
	pass

func get_score() -> int: 
	return score

func _on_trigger_area_area_entered(area):
	if area.get_parent().name == "Ball" and area.get_parent().get_last_owner() == $Node2D.player_side:
		color_keep = $TriggerArea.modulate
		$TriggerArea.modulate = Color.RED
		is_scorable = true
		$ScoreArea.show()


func _on_trigger_area_area_exited(area):
	if area.get_parent().name == "Ball" and area.get_parent().get_last_owner() == $Node2D.player_side:
		$TriggerArea.modulate = color_keep
		is_scorable = false
		$ScoreArea.hide()


func _on_score_area_area_entered(area):
	if area.get_parent().name == "Ball" and is_scorable and area.get_parent().get_last_owner() == $Node2D.player_side:
		is_scorable = false
		score += 1
