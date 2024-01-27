extends Node2D

@export_category("Nodes")
@export_node_path("Node2D") var in_between = NodePath("../In-between")

@export_node_path("Node") var p1_laugh_bar = NodePath("../Life bars/Laugh bar P1")
@export_node_path("Node") var p2_laugh_bar = NodePath("../Life bars/Laugh bar P2")

@export_node_path("Node") var options = NodePath("Minigame chooser/Panel/Options")

@export_category("Minigames")
@export var minigame_folders: Array[String]

@export_category("Points")
@export_range(0, 100, 0.01) var p1_points = 10.0
@export_range(0, 100, 0.01) var p2_points = 10.0

@onready var in_between_node = get_node(in_between)
@onready var options_node = get_node(options)

@onready var p1_laugh_bar_node = get_node(p1_laugh_bar)
@onready var p2_laugh_bar_node = get_node(p2_laugh_bar)

var minigames: Array[Minigame]
var current_minigame: Minigame
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
	p1_laugh_bar_node.hide()
	p2_laugh_bar_node.hide()
	$"Minigame chooser".hide()
	
	var old_viewport = get_viewport()
	old_camera = old_viewport.get_camera_2d()
	old_camera.enabled = false
	
	in_between_node.process_mode = PROCESS_MODE_DISABLED
	in_between_node.hide()
	
	var number_of_difficulties = minigame.scenes.size()
	var scene_index = clamp(floor(number_of_difficulties * difficulty), 0, number_of_difficulties)
	var scene = minigame.scenes[scene_index].instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	
	for child in $Contents.get_children():
		child.free()
	$Contents.add_child(scene)
	
	var timer: SceneTreeTimer = get_tree().create_timer(0.3)
	timer.timeout.connect(
		func ():
			var viewport = get_viewport()
			var camera = viewport.get_camera_2d()
			var tween: Tween = get_tree().create_tween().set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($"Left curtain", "position", initial_left_curtain_pos / camera.zoom, 0.5)
			tween.tween_property($"Right curtain", "position", initial_right_curtain_pos / camera.zoom, 0.5)
	)

func load_minigame(minigame: Minigame, difficulty: float = 0.0):
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
	p1_laugh_bar_node.show()
	p2_laugh_bar_node.show()
	$"Minigame chooser".show()
	
	in_between_node.process_mode = PROCESS_MODE_INHERIT
	in_between_node.show()
	
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
				get_tree().create_timer(0.15).timeout.connect(func():
					p1_laugh_bar_node.update_bar()
					p2_laugh_bar_node.update_bar()
				)
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
	var scenes: Array
	var points: Dictionary = {
		"win": 10,
		"tie": -5,
		"lose": 0
	}

func end_minigame_callback(end_state: MinigameEndState):
	match end_state:
		MinigameEndState.P1Won:
			$Announcements.text = "¡Jugador 1 ganó el minijuego!"
			p1_points += current_minigame.points.get("win")
			p2_points += current_minigame.points.get("lose")
		MinigameEndState.P2Won:
			$Announcements.text = "¡Jugador 2 ganó el minijuego!"
			p1_points += current_minigame.points.get("lose")
			p2_points += current_minigame.points.get("win")
		MinigameEndState.Tie:
			$Announcements.text = "Bue un empate :P"
			p1_points += current_minigame.points.get("tie")
			p2_points += current_minigame.points.get("tie")
			pass
		MinigameEndState.BothWon:
			$Announcements.text = "Los dos ganaron???? >:("
			p1_points += current_minigame.points.get("both_win", current_minigame.points.get("win"))
			p2_points += current_minigame.points.get("both_win", current_minigame.points.get("win"))
		MinigameEndState.BothLost:
			$Announcements.text = "Todos perdieron >:)"
			p1_points += current_minigame.points.get("both_lose", current_minigame.points.get("lose"))
			p2_points += current_minigame.points.get("both_lose", current_minigame.points.get("lose"))
	p1_points = clamp(p1_points, 0, 100)
	p2_points = clamp(p2_points, 0, 100)
	if p1_points == 100 && p2_points == 100:
		$Announcements.text = "???? Los dos jugadores ganaron la partida ?????\n(Insertar chistes o algo no se)"
	elif p1_points == 100:
		$Announcements.text = "¡Jugador 1 ganó la partida!"
	elif p2_points == 100:
		$Announcements.text = "¡Jugador 2 ganó la partida!"
	p1_laugh_bar_node.points = p1_points
	p2_laugh_bar_node.points = p2_points

func _ready():
	end_minigame.connect(end_minigame_callback)
	p1_laugh_bar_node.points = p1_points
	p2_laugh_bar_node.points = p2_points
	p1_laugh_bar_node.update_bar()
	p2_laugh_bar_node.update_bar()
	for folder in minigame_folders:
		var info_path = folder.path_join("info.ini")
		var info = ConfigFile.new()
		if info.load(info_path) == ERR_FILE_CANT_OPEN:
			# TODO: Add error screen
			return
		var minigame = Minigame.new()
		minigame.name = info.get_value("minigame", "name", "[SIN NOMBRE]")
		minigame.id = info.get_value("minigame", "id")
		var difficulties: Array = info.get_value("minigame", "difficulties", ["game.tscn"]).map(func(scene_filename): return folder.path_join(scene_filename))
		minigame.scenes = difficulties.map(func(scene_path): return load(scene_path))
		var points_keys = info.get_section_keys("points")
		for key in points_keys:
			minigame.points[key] = info.get_value("points", key)
		minigames.push_back(minigame)
		print("Loaded " + minigame.id)
	
	randomize()
	
	var nodes = []
	for minigame in minigames:
		var option_label = Label.new()
		option_label.text = minigame.name
		option_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		option_label.anchors_preset = Control.LayoutPreset.PRESET_TOP_WIDE
		option_label.anchor_right = 1.0
		option_label.set_meta("id", minigame.id)
		#option_label.anchor_bottom = 1.0
		option_label.position.y = 0
		#option_label.modulate.a = 0
		nodes.push_back(option_label)
	nodes.shuffle()
	
	for node in nodes:
		options_node.add_child(node)

func _process(_delta):
	p1_laugh_bar_node.points = p1_points
	p2_laugh_bar_node.points = p2_points

func _input(_event):
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_Z):
			load_minigame(minigames[1], 0)
		elif Input.is_key_pressed(KEY_X):
			unload_minigame()
