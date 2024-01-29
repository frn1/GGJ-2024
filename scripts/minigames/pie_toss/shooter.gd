extends Node2D

@export_enum("No player", "P1", "P2") var player = 1
@export var rotation_speed: float = 260

@export var minimum_rotation_angle = -35
@export var maximum_rotation_angle = 90

var projectile: PackedScene

@export var cooldown: float = 0.2

@export var projectile_speed: float = 30

@export_node_path("Label") var score_label

var score = 0

func update_icons():
	if $PromptShoot:
		$PromptShoot.texture = ResourceLoader.load(Controller.find_tex_path_for_action("action", player))
	if $CCWArrow/Prompt:
		$CCWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("left", player))
	if $CWArrow/Prompt:
		$CWArrow/Prompt.texture = ResourceLoader.load(Controller.find_tex_path_for_action("right", player))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_icons()
	Controller.controller_changed.connect(
		func (_new_mode, _device):
			update_icons()
	)
	var gun_pos = $Gun.position
	$Gun.replace_by(load("res://minigames/pie_toss/p%d_gun.tscn" % player).instantiate())
	$Gun.position = gun_pos
	projectile = load("res://minigames/pie_toss/p%d_projectile.tscn" % player)

@onready var timeout_timer = get_tree().create_timer(cooldown)

func _input(event):
	if event.is_action_pressed(Controller.format_action_id("action", player)):
		if timeout_timer.time_left == 0:
			$lanzamiento.play()
			var projectile_node = projectile.instantiate()
			get_parent().add_child(projectile_node)
			projectile_node.global_position = $Gun.global_position
			projectile_node.global_rotation = $Gun.global_rotation
			projectile_node.add_score = func():
				$fuegoA.play()
				$contador.play()
				score += 1
				get_node(score_label).text = str(score)
			projectile_node.speed = projectile_speed
			timeout_timer = get_tree().create_timer(cooldown)

func _process(delta):
	var direction = Input.get_axis(Controller.format_action_id("left", player), Controller.format_action_id("right", player))
	rotation += direction * delta * deg_to_rad(rotation_speed)
	rotation = clamp(rotation, deg_to_rad(minimum_rotation_angle), deg_to_rad(maximum_rotation_angle))
	$Body.rotation += direction * delta * deg_to_rad(rotation_speed) * 0.8
