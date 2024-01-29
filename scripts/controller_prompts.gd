extends Sprite2D

@export_enum("No player", "Player 1", "Player 2") var player = 1

var action_id

func update_prompt():
	texture = load(Controller.find_tex_path_for_action(action_id, player))

func _ready():
	action_id = texture.resource_path.get_file().get_basename()
	update_prompt()
	Controller.controller_changed.connect(
		func():
			update_prompt()
	)
