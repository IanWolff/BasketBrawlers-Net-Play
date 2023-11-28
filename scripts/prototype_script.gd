extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreBoard/HomeScore/Label.text = "0"
	$ScoreBoard/AwayScore/Label.text = "0"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ScoreBoard/HomeScore/Label.text = str($RightHoop.get_score())
	$ScoreBoard/AwayScore/Label.text = str($LeftHoop.get_score())
