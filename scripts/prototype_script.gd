extends Node2D

var home_score : int = 0
var away_score : int = 0
var has_scored : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreBoard/HomeScore/Label.text = "0"
	$ScoreBoard/AwayScore/Label.text = "0"
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !has_scored:
		if $LeftHoop.get_score() > away_score:
			away_score = $LeftHoop.get_score()
			$ScoreBoard/HomeScore/Label.text = str(away_score)
			has_scored = true
			$ResetTimer.start()
			$Ball.disable()
		elif $RightHoop.get_score() > home_score:
			home_score = $RightHoop.get_score()
			$ScoreBoard/HomeScore/Label.text = str(home_score)
			has_scored = true
			$ResetTimer.start()
			$Ball.disable()
	elif has_scored and $ResetTimer.is_stopped():
		$Ball.modulate.a = 1
		$Ball.reset()
		has_scored = false	
	else:
		$Ball.modulate.a -= 0.02
