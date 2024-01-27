extends Node2D

@export_enum("No player", "P1", "P2") var player = 1
@export var rotation_speed: float = 260

@export var minimum_rotation_angle = -35
@export var maximum_rotation_angle = 90

@export var projectile: PackedScene

@export var cooldown: float = 0.2

@export var projectile_speed: float = 25

@export_node_path("Label") var score_label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$PromptShoot.texture = ResourceLoader.load(Controller.find_tex_path_for_action("action", player))
	$CCWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("left", player))
	$CWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("right", player))

@onready var timeout_timer = get_tree().create_timer(cooldown)

func _input(event):
	if event.is_action_pressed(Controller.format_action_id("action", player)):
		if timeout_timer.time_left == 0:
			var projectile_node = projectile.instantiate()
			get_parent().add_child(projectile_node)
			projectile_node.global_position = $Gun.global_position
			projectile_node.global_rotation = $Gun.global_rotation
			projectile_node.add_score = func():
				score += 1
				get_node(score_label).text = str(score)
			projectile_node.speed = projectile_speed
			timeout_timer = get_tree().create_timer(cooldown)

func _process(delta):
	var direction = Input.get_axis(Controller.format_action_id("left", player), Controller.format_action_id("right", player))
	rotation += direction * delta * deg_to_rad(rotation_speed)
	rotation = clamp(rotation, deg_to_rad(minimum_rotation_angle), deg_to_rad(maximum_rotation_angle))
