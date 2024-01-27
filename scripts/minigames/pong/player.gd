extends StaticBody2D

@export var speed = 550
@export var min_y_pos = -245
@export var max_y_pos = 245

@export_enum("No player", "Player 1", "Player 2") var player = 1

func update_icons(player):
	#$PromptShoot.texture = ResourceLoader.load(Controller.find_tex_path_for_action("action", player))
	if $UpPrompt:
		$UpPrompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("up", player))
	if $DownPrompt:
		$DownPrompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("down", player))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_icons(player)
	Controller.controller_changed.connect(
		func (_new_mode, _player):
			update_icons(player)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_axis(Controller.format_action_id("up", player), Controller.format_action_id("down", player))
	global_position.y += direction * speed * delta
	global_position.y = clamp(global_position.y, min_y_pos, max_y_pos)
