extends Node

var current_modes = ["Keyboard", "Keyboard"]

signal controller_changed(new_mode: String)

func find_tex_path_for_action(action: String, player: int) -> String:
	var path = "res://textures/Controller Icons".path_join(current_modes[player - 1])
	if current_modes[player - 1] == "Keyboard":
		path = path.path_join("P" + str(player))
	return path.path_join(action) + ".png"

func format_action_id(action: String, player: int) -> String:
	return "P" + str(player) + " " + action

func _ready():
	Input.joy_connection_changed.connect(
		func(device: int, connected: bool):
			var name = Input.get_joy_name(device).to_upper()
			print(name)
			if connected == false:
				current_modes[device] = "Keyboard"
			elif name.contains("XBOX"):
				if name.contains("SERIES"):
					current_modes[device] = "Xbox Series"
				elif name.contains("WIRELESS") || name.contains("CONTROLLER") || name.contains("ONE"):
					current_modes[device] = "Xbox One"
				else:
					current_modes[device] = "Xbox 360"
			elif name.contains("XINPUT"):
				current_modes[device] = "Xbox One"
			elif name.contains("PS3") || name.contains("PLAYSTATION(R)3") || ((name.contains("PLAYSTATION") || name.contains("PS") || name.contains("DS")) && name.contains("3")):
				current_modes[device] = "PS3"
			elif name.contains("PS4") || name.contains("PLAYSTATION(R)4") || ((name.contains("PLAYSTATION") || name.contains("PS") || name.contains("DS")) && name.contains("4")):
				current_modes[device] = "PS4"
			elif name.contains("PS5") || name.contains("PLAYSTATION(R)5") || ((name.contains("PLAYSTATION") || name.contains("PS") || name.contains("DS")) && name.contains("5")):
				current_modes[device] = "PS5"
			elif name.contains("PLAYSTATION") || name.contains("PS") || name.contains("DS") || name.contains("VITA"):
				current_modes[device] = "PS Vita"
			elif name.contains("STADIA"):
				current_modes[device] = "Stadia"
			elif name.contains("OUYA"):
				current_modes[device] = "Ouya"
			elif name.contains("SWITCH") || name.contains("PRO") || name.contains("JOY"):
				current_modes[device] = "Switch"
			elif name.contains("WIIU") || name.contains("WII U"):
				current_modes[device] = "Wii U"
			elif name.contains("WII"):
				current_modes[device] = "Wii"
			elif name.contains("STEAM"):
				if name.contains("DECK"):
					current_modes[device] = "Steam Deck"
				else:
					current_modes[device] = "Steam"
			else:
				current_modes[device] = "Luna"
			controller_changed.emit(current_modes[device])
	)
