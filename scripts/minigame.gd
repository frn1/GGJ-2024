extends Node2D

@export_category("Nodes")
@export_node_path("Node2D") var in_between = NodePath("../In-between")

@export_node_path("Node") var p1_laugh_bar = NodePath("../Life bars/Laugh bar P1")
@export_node_path("Node") var p2_laugh_bar = NodePath("../Life bars/Laugh bar P2")

@export_category("Minigames")
@export var minigame_folders: Array[String]

@export_category("Points")
@export_range(0, 100, 0.01) var p1_points = 10.0
@export_range(0, 100, 0.01) var p2_points = 10.0

@onready var in_between_node = get_node(in_between)

@onready var p1_laugh_bar_node = get_node(p1_laugh_bar)
@onready var p2_laugh_bar_node = get_node(p2_laugh_bar)

var minigames: Array[Minigame]
var current_minigame: Minigame
var old_camera

@onready var initial_curtain_pos = $"Curtain".position

signal transition_done

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
	
	in_between_node.process_mode = PROCESS_MODE_DISABLED
	in_between_node.hide()
	
	var number_of_difficulties = minigame.scenes.size()
	var scene_index = clamp(floor(number_of_difficulties * difficulty), 0, number_of_difficulties)
	var scene = minigame.scenes[scene_index].instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	
	for child in $TV/Contents/Viewport.get_children():
		child.free()
	$TV/Contents/Viewport.add_child(scene)
	
	$TV.show()
	
	var timer: SceneTreeTimer = get_tree().create_timer(0.3)
	timer.timeout.connect(
		func ():
			var viewport = get_viewport()
			var camera = viewport.get_camera_2d()
			var tween: Tween = get_tree().create_tween().set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($"Curtain", "position", initial_curtain_pos / camera.zoom, 0.5)
	)

func load_minigame(minigame: Minigame, difficulty: float = 0.0):
	if current_minigame != null:
		push_error("Attempted to load a minigame while another was loaded")
		return
	
	current_minigame = minigame
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Curtain", "position", Vector2(0, -210), 0.5)
	tween.finished.connect(func (): after_curtains_enter_load(minigame, difficulty))

func after_curtains_enter_unload():
	print("Unloading current minigame")
	
	$"Minigame chooser".generate_nodes()
	
	$Announcements.show()
	p1_laugh_bar_node.show()
	p2_laugh_bar_node.show()
	$"Minigame chooser".enabled = false
	
	in_between_node.process_mode = PROCESS_MODE_INHERIT
	in_between_node.show()
	
	for child in $TV/Contents/Viewport.get_children():
		child.free()
	
	current_minigame = null
	
	$TV.hide()
	
	var timer: SceneTreeTimer = get_tree().create_timer(0.3)
	timer.timeout.connect(
		func ():
			var tween: Tween = get_tree().create_tween().set_parallel(true)
			tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($"Curtain", "position", initial_curtain_pos, 0.5)
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
				if p1_laugh_bar_node.points == 100 || p2_laugh_bar_node.points == 100:
					await get_tree().create_timer(3.0).timeout
					go_to_main_menu()
				else:
					get_tree().create_timer(3.0).timeout.connect(slide_minigame_chooser_up)
				#p1_node.process_mode = PROCESS_MODE_INHERIT
				#p2_node.process_mode = PROCESS_MODE_INHERIT
			)
	)

	
func slide_minigame_chooser_up():
	var original_pos = $"Minigame chooser".position
	$"Minigame chooser".position.y += $"Minigame chooser/Body".get_rect().size.y * $"Minigame chooser/Body".scale.y
	$"Minigame chooser".show()
	var minigame_chooser_tween = create_tween()
	minigame_chooser_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	minigame_chooser_tween .tween_property($"Minigame chooser", "position", original_pos, 0.7)
	await minigame_chooser_tween.finished
	await get_tree().create_timer(0.2).timeout
	$"Minigame chooser".enabled = true

func unload_minigame():
	if current_minigame == null:
		push_error("Attempted to unload the current minigame without a minigame loaded")
		return
		
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($"Curtain", "position", Vector2(0, -210), 0.5)
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
	var viewport_rect = get_viewport_rect()
	var root_curtain = get_node("/root/Curtain")
	root_curtain.position -= viewport_rect.size / 2 
	var curtain_tween = create_tween()
	curtain_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	curtain_tween.tween_property(root_curtain, "position", initial_curtain_pos, 0.8)
	curtain_tween.finished.connect(
		func():
			transition_done.emit()
			root_curtain.hide()
	)
	end_minigame.connect(end_minigame_callback)
	p1_laugh_bar_node.points = p1_points
	p2_laugh_bar_node.points = p2_points
	p1_laugh_bar_node.update_bar()
	p2_laugh_bar_node.update_bar()
	await %Dialog.play(preload("res://dialogs/start.csv"))
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
	
	seed(round(Time.get_unix_time_from_system() * 497))
	
	$"Minigame chooser".enabled = false
	$"Minigame chooser".load_minigames(minigames)
	$"Minigame chooser".generate_nodes()
	$"Minigame chooser".hide()
	await get_tree().create_timer(2.0).timeout
	slide_minigame_chooser_up()
	
	seed(round(Time.get_unix_time_from_system() * 169))

func _process(_delta):
	p1_laugh_bar_node.points = p1_points
	p2_laugh_bar_node.points = p2_points

func go_to_main_menu():
	var viewport_rect = get_viewport_rect()
	var root_curtain = get_node("/root/Curtain")
	root_curtain.show()
	root_curtain.position.x = 0
	root_curtain.position.y = -root_curtain.texture.get_height() * root_curtain.scale.y * 0.5 
	root_curtain.position.y -= viewport_rect.size.y / 2
	var curtain_tween = create_tween()
	curtain_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	curtain_tween.tween_property(root_curtain, "position", Vector2(0, -viewport_rect.size.y / 2 + 100), 1.0)
	curtain_tween.finished.connect(
		func():
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_packed(load("res://scenes/menus/main_menu.tscn"))
	)

func _input(_event):
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_1):
			load_minigame(minigames[0], 0)
		elif Input.is_key_pressed(KEY_2):
			load_minigame(minigames[1], 0)
		elif Input.is_key_pressed(KEY_3):
			load_minigame(minigames[2], 0)
		elif Input.is_key_pressed(KEY_Z):
			p1_points = 95
			p1_laugh_bar_node.update_bar()
			p2_laugh_bar_node.update_bar()
		elif Input.is_key_pressed(KEY_C):
			p2_points = 95
			p1_laugh_bar_node.update_bar()
			p2_laugh_bar_node.update_bar()
		elif Input.is_key_pressed(KEY_X):
			unload_minigame()
		elif Input.is_key_pressed(KEY_V):
			go_to_main_menu()
