extends StaticBody2D

# Properties
const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0

# States
var is_scorable : bool = false

# Values
var score : int = 0

# Utilities
var color_keep : Color
signal score_update

func _ready():
	$Score_Area.hide()

func get_score() -> int: 
	return score

# Signal Methods
func _on_trigger_area_area_entered(area):
	if area.get_parent().name == "Ball" and area.get_parent().get_last_owner() == $Node2D.player_side:
		color_keep = $Trigger_Area.modulate
		$Trigger_Area.modulate = Color.RED
		is_scorable = true
		$Score_Area.show()

func _on_trigger_area_area_exited(area):
	if area.get_parent().name == "Ball" and area.get_parent().get_last_owner() == $Node2D.player_side:
		$Trigger_Area.modulate = color_keep
		is_scorable = false
		$Score_Area.hide()

func _on_score_area_area_entered(area):
	if area.get_parent().name == "Ball" and is_scorable and area.get_parent().get_last_owner() == $Node2D.player_side:
		score += 1
		is_scorable = false
		emit_signal("score_update")
