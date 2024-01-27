extends Node

var current_modes = ["Xbox One", "Keyboard"]

func find_tex_path_for_action(action: String, player: int) -> String:
	var path = "res://textures/Controller Icons".path_join(current_modes[player - 1])
	if current_modes[player - 1] == "Keyboard":
		path = path.path_join("P" + str(player))
	return path.path_join(action) + ".png"

func format_action_id(action: String, player: int) -> String:
	return "P" + str(player) + " " + action
