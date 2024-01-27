extends Node2D

@export var minigame_duration = 35.0

enum Buttons {
	Left,
	Right,
	Up,
	Down,
	Action
}

var next_action_index: Array[int] = [0, 0]
var scores: Array[int] = [0, 0]
var actions: Array[Array]

var rng: RandomNumberGenerator

var player = 1

func generate_keys_for_player(player: int):
	for node in get_node("Steps P" + str(player)).get_children():
		node.free()
	rng.randomize()
	next_action_index.resize(2)
	next_action_index[player - 1] = 0
	actions.resize(2)
	actions[player - 1] = []
	for i in range(0, 5):
		# Gives A/Space a slightly higher chance
		var button_chosen = Buttons.values().pick_random()
		if button_chosen == Buttons.Action:
			rng.randomize()
		actions[player - 1].push_back(button_chosen)
	var next_x_pos = 0
	for i in range(0, actions[player - 1].size()):
		var action = actions[player - 1][i]
		var path = ""
		match action:
			Buttons.Left:
				path = Controller.find_tex_path_for_action("left", player)
			Buttons.Down:
				path = Controller.find_tex_path_for_action("down", player)
			Buttons.Up:
				path = Controller.find_tex_path_for_action("up", player)
			Buttons.Right:
				path = Controller.find_tex_path_for_action("right", player)
			Buttons.Action:
				path = Controller.find_tex_path_for_action("action", player)
		var sprite = Sprite2D.new()
		sprite.name = str(i)
		sprite.texture = ResourceLoader.load(path)
		sprite.position.x += next_x_pos
		next_x_pos += sprite.get_rect().size.x
		get_node("Steps P" + str(player)).add_child(sprite)

var start_time: float

func _ready():
	rng = RandomNumberGenerator.new()
	generate_keys_for_player(1)
	generate_keys_for_player(2)
	start_time = Time.get_ticks_usec() / 1e+6

var Minigame = preload("res://scripts/minigame.gd")
var minigame_ended = false

func _process(_delta):
	var remaining_time = maxf(minigame_duration - (Time.get_ticks_usec() / 1e+6 - start_time), 0.0)
	$Time.text = "%.2f s" % remaining_time
	if is_zero_approx(remaining_time):
		if minigame_ended:
			return
		if scores[0] > scores[1]:
			get_parent().end_minigame(Minigame.MinigameEndState.P1Won)
		elif scores[1] > scores[0]:
			get_parent().end_minigame(Minigame.MinigameEndState.P2Won)
		else:
			get_parent().end_minigame(Minigame.MinigameEndState.Tie)
		minigame_ended = true
		return
	
	for sprite in $"Steps P1".get_children():
		if next_action_index[0] - 1 < sprite.name.to_int():
			sprite.show()
		else:
			sprite.hide()
	for sprite in $"Steps P2".get_children():
		if next_action_index[1] - 1 < sprite.name.to_int():
			sprite.show()
		else:
			sprite.hide()
	if next_action_index[0] == 5:
		scores[0] += 1
		$"Points P1".text = str(scores[0])
		generate_keys_for_player(1)
	if next_action_index[1] == 5:
		scores[1] += 1
		$"Points P2".text = str(scores[1])
		generate_keys_for_player(2)

func _input(event):
	if event.is_action_pressed(Controller.format_action_id("action", 1)):
		if actions[0][next_action_index[0]] == Buttons.Action:
			next_action_index[0] += 1
		else:
			next_action_index[0] = 0
	if event.is_action_pressed(Controller.format_action_id("up", 1)):
		if actions[0][next_action_index[0]] == Buttons.Up:
			next_action_index[0] += 1
		else:
			next_action_index[0] = 0
	if event.is_action_pressed(Controller.format_action_id("down", 1)):
		if actions[0][next_action_index[0]] == Buttons.Down:
			next_action_index[0] += 1
		else:
			next_action_index[0] = 0
	if event.is_action_pressed(Controller.format_action_id("left", 1)):
		if actions[0][next_action_index[0]] == Buttons.Left:
			next_action_index[0] += 1
		else:
			next_action_index[0] = 0
	if event.is_action_pressed(Controller.format_action_id("right", 1)):
		if actions[0][next_action_index[0]] == Buttons.Right:
			next_action_index[0] += 1
		else:
			next_action_index[0] = 0
			
	if event.is_action_pressed(Controller.format_action_id("action", 2)):
		if actions[1][next_action_index[1]] == Buttons.Action:
			next_action_index[1] += 1
		else:
			next_action_index[1] = 0
	if event.is_action_pressed(Controller.format_action_id("up", 2)):
		if actions[1][next_action_index[1]] == Buttons.Up:
			next_action_index[1] += 1
		else:
			next_action_index[1] = 0
	if event.is_action_pressed(Controller.format_action_id("down", 2)):
		if actions[1][next_action_index[1]] == Buttons.Down:
			next_action_index[1] += 1
		else:
			next_action_index[1] = 0
	if event.is_action_pressed(Controller.format_action_id("left", 2)):
		if actions[1][next_action_index[1]] == Buttons.Left:
			next_action_index[1] += 1
		else:
			next_action_index[1] = 0
	if event.is_action_pressed(Controller.format_action_id("right", 2)):
		if actions[1][next_action_index[1]] == Buttons.Right:
			next_action_index[1] += 1
		else:
			next_action_index[1] = 0
	next_action_index[0] = clamp(next_action_index[0], 0, 4)
	next_action_index[1] = clamp(next_action_index[1], 0, 4)
