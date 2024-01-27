extends Node2D

@export_enum("No player", "P1", "P2") var player = 1
@export var rotation_speed: float = 230

@export var minimum_rotation_angle = -35
@export var maximum_rotation_angle = 90

@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$PromptShoot.texture = ResourceLoader.load(Controller.find_tex_path_for_action("action", player))
	$CCWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("left", player))
	$CWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("right", player))

func _input(event):
	if event.is_action_pressed(Controller.format_action_id("action", player)):
		var projectile = projectile.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.global_rotation = global_rotation

func _process(delta):
	var direction = Input.get_axis(Controller.format_action_id("left", player), Controller.format_action_id("right", player))
	rotation += direction * delta * deg_to_rad(rotation_speed)
	rotation = clamp(rotation, deg_to_rad(minimum_rotation_angle), deg_to_rad(maximum_rotation_angle))
