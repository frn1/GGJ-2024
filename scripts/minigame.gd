extends Node2D

@export_category("Nodes")
@export_node_path("Node2D") var in_between = NodePath("../In-between")
@export_node_path("CharacterBody2D") var player1 = NodePath("../Player 1")
@export_node_path("CharacterBody2D") var player2 = NodePath("../Player 2")

@export_node_path("Node") var p1_laugh_bar = NodePath("../Life bars/Laugh bar P1")
@export_node_path("Node") var p2_laugh_bar = NodePath("../Life bars/Laugh bar P2")

@export_category("Minigames")
@export var minigame_folders: Array[String]

@export_category("Points")
@export_range(-100, 100, 0.01) var points_added_from_winning = 15.0
@export_range(-100, 100, 0.01) var points_added_from_losing = -2.0

@export_range(0, 100, 0.01) var p1_points = 10.0
@export_range(0, 100, 0.01) var p2_points = 10.0

@onready var in_between_node = get_node(in_between)
@onready var p1_node = get_node(player1)
@onready var p2_node = get_node(player2)

var minigames: Array[Minigame]
var current_minigame
var old_camera

@onready var initial_left_curtain_pos = $"Left curtain".position
@onready var initial_right_curtain_pos = $"Right curtain".position

enum MinigameEndState {
	P1Won,
	P2Won,
	Tie,
	BothLost,
	BothWon
}

signal end_minigame(end_state: MinigameEndState)

func after_curtains_enter_load(minigame: Minigame, difficulty: float):
	print("Loading minigame " + minigame.id)
	
	$Announcements.hide()
	
	var old_viewport = get_viewport()
	old_camera = old_viewport.get_camera_2d()
	old_camera.enabled = false
	
	in_between_node.process_mode = PROCESS_MODE_DISABLED
	in_between_node.hide()
	
	var number_of_difficulties = minigame.scenes.size()
	var scene_index = clamp(floor(number_of_difficulties * difficulty), 0, number_of_difficulties)
	var scene = minigame.scenes[scene_index].instantiate()
	
	if minigame.include_players == false:
		#p1_node.enabled = false
		p1_node.process_mode = PROCESS_MODE_DISABLED
		p1_node.hide()
		#p2_node.enabled = false
		p2_node.process_mode = PROCESS_MODE_DISABLED
		p2_node.hide()
	else:
		var spawn_p1 = scene.get_node("Spawn P1")
		var spawn_p2 = scene.get_node("Spawn P2")
		p1_node.global_position = spawn_p1.global_position
		p1_node.velocity = Vector2.ZERO
		p2_node.global_position = spawn_p2.global_position
		p2_node.velocity = Vector2.ZERO
	
	for child in $Contents.get_children():
		child.free()
	$Contents.add_child(scene)
	
	var timer: SceneTreeTimer = get_tree().create_timer(0.3)
	timer.timeout.connect(
		func ():
			var tween: Tween = get_tree().create_tween().set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($"Left curtain", "position", initial_left_curtain_pos, 0.5)
			tween.tween_property($"Right curtain", "position", initial_right_curtain_pos, 0.5)
	)

func load_minigame(minigame: Minigame, difficulty: float):
	if current_minigame != null:
		push_error("Attempted to load a minigame while another was loaded")
		return
	
	current_minigame = minigame
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Left curtain", "position", Vector2.ZERO, 0.5)
	tween.tween_property($"Right curtain", "position", Vector2.ZERO, 0.5)
	tween.finished.connect(func (): after_curtains_enter_load(minigame, difficulty))

func after_curtains_enter_unload():
	print("Unloading current minigame")
	
	$Announcements.show()
	
	in_between_node.process_mode = PROCESS_MODE_INHERIT
	in_between_node.show()
	
	#p2_node.enabled = true
	p1_node.show()
	p1_node.process_mode = PROCESS_MODE_INHERIT
	#p2_node.enabled = true
	p2_node.show()
	p2_node.process_mode = PROCESS_MODE_INHERIT
	
	if current_minigame.include_players == true:
		var spawn_p1 = in_between_node.get_node("Spawn P1")
		var spawn_p2 = in_between_node.get_node("Spawn P2")
		p1_node.global_position = spawn_p1.global_position
		p1_node.velocity = Vector2.ZERO
		p2_node.global_position = spawn_p2.global_position
		p2_node.velocity = Vector2.ZERO
	
	for child in $Contents.get_children():
		child.free()
	
	old_camera.enabled = true
	
	current_minigame = null
	
	var timer: SceneTreeTimer = get_tree().create_timer(0.3)
	timer.timeout.connect(
		func ():
			var tween: Tween = get_tree().create_tween().set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($"Left curtain", "position", initial_left_curtain_pos, 0.5)
			tween.tween_property($"Right curtain", "position", initial_right_curtain_pos, 0.5)
			tween.finished.connect(func(): 
				get_tree().create_timer(5.0).timeout.connect(
					func():
						$Announcements.hide()
						$Announcements.text = ""
				)
				#p1_node.process_mode = PROCESS_MODE_INHERIT
				#p2_node.process_mode = PROCESS_MODE_INHERIT
			)
	)

func unload_minigame():
	if current_minigame == null:
		push_error("Attempted to unload the current minigame without a minigame loaded")
		return
		
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Left curtain", "position", Vector2.ZERO, 0.5)
	tween.tween_property($"Right curtain", "position", Vector2.ZERO, 0.5)
	tween.finished.connect(after_curtains_enter_unload)

class Minigame:
	var name: String
	var id: String
	var include_players: bool
	var scenes: Array

func end_minigame_callback(end_state: MinigameEndState):
	match end_state:
		MinigameEndState.P1Won:
			$Announcements.text = "¡Jugador 1 ganó el minijuego!"
			p1_points += points_added_from_winning
			p2_points += points_added_from_losing
		MinigameEndState.P2Won:
			$Announcements.text = "¡Jugador 2 ganó el minijuego!"
			p1_points += points_added_from_losing
			p2_points += points_added_from_winning
		MinigameEndState.Tie:
			$Announcements.text = "Bue un empate :P"
			pass
		MinigameEndState.BothWon:
			$Announcements.text = "Los dos ganaron???? >:("
			p1_points += points_added_from_winning
			p2_points += points_added_from_winning
		MinigameEndState.BothLost:
			$Announcements.text = "Todos perdieron >:)"
			p1_points += points_added_from_losing
			p2_points += points_added_from_losing
	p1_points = clamp(p1_points, 0, 100)
	p2_points = clamp(p2_points, 0, 100)
	if p1_points == 100 && p2_points == 100:
		$Announcements.text = "???? Los dos jugadores ganaron la partida ?????\n(Insertar chistes o algo no se)"
	elif p1_points == 100:
		$Announcements.text = "¡Jugador 1 ganó la partida!"
	elif p2_points == 100:
		$Announcements.text = "¡Jugador 2 ganó la partida!"
	get_node(p1_laugh_bar).change_points(p1_points)
	get_node(p2_laugh_bar).change_points(p2_points)

func _ready():
	end_minigame.connect(end_minigame_callback)
	get_node(p1_laugh_bar).change_points(p1_points)
	get_node(p2_laugh_bar).change_points(p2_points)
	for folder in minigame_folders:
		var info_path = folder.path_join("info.ini")
		var info = ConfigFile.new()
		if info.load(info_path) == ERR_FILE_CANT_OPEN:
			# TODO: Add error screen
			return
		var minigame = Minigame.new()
		minigame.name = info.get_value("minigame", "name", "[NO NAME]")
		minigame.id = info.get_value("minigame", "id")
		minigame.include_players = info.get_value("minigame", "include_players", false)
		var difficulties: Array = info.get_value("minigame", "difficulties", ["game.tscn"]).map(func(scene_filename): return folder.path_join(scene_filename))
		minigame.scenes = difficulties.map(func(scene_path): return load(scene_path))
		minigames.push_back(minigame)
		print("Loaded " + minigame.id)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		load_minigame(minigames.pick_random(), 0)
	elif Input.is_action_just_pressed("ui_down"):
		unload_minigame()
