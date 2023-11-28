extends Control

var time_elapsed : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	$GameTime/Label.text = format_time(time_elapsed)

func format_time(total_seconds : float) -> String:
	var seconds : float = fmod(total_seconds , 60.0)
	var minutes : int   =  int(total_seconds / 60.0) % 60
	var time_string : String = "%02d:%05.2f" % [minutes, seconds]
	return time_string
