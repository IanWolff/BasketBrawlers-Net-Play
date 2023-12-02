extends Node2D

enum player_side {HOME, AWAY, NONE}

func get_player_color(player : player_side) -> Color:
	if player == player_side.HOME:
		return Color.GOLD
	elif player == player_side.AWAY:
		return Color.RED
	else:
		return Color(1, 1, 1)
