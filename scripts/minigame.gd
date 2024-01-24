extends Node2D

@export_node_path("Node2D") var in_between = NodePath("../In-between")
@export_node_path("CharacterBody2D") var player1 = NodePath("../Player 1")
@export_node_path("CharacterBody2D") var player2 = NodePath("../Player 2")

@export var minigame_folders: Array[String]

@onready var in_between_node = get_node(in_between)
@onready var p1_node = get_node(player1)
@onready var p2_node = get_node(player2)

var minigames: Array[Minigame]
var current_minigame
var old_camera

func load_minigame(minigame: Minigame, difficulty: float):
	if current_minigame != null:
		push_error("Attempted to load a minigame while another was loaded")
		return
		
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
	
	var viewport = get_node("SubViewport")
	
	for child in viewport.get_children():
		child.free()
	viewport.add_child(scene)
	
	current_minigame = minigame

func unload_minigame():
	if current_minigame == null:
		push_error("Attempted to unload the current minigame without a minigame loaded")
		return
	
	in_between_node.process_mode = PROCESS_MODE_INHERIT
	in_between_node.show()
	
	#p2_node.enabled = true
	p1_node.process_mode = PROCESS_MODE_INHERIT
	p1_node.show()
	#p2_node.enabled = true
	p2_node.process_mode = PROCESS_MODE_INHERIT
	p2_node.show()
	
	if current_minigame.include_players == true:
		var spawn_p1 = in_between_node.get_node("Spawn P1")
		var spawn_p2 = in_between_node.get_node("Spawn P2")
		p1_node.global_position = spawn_p1.global_position
		p1_node.velocity = Vector2.ZERO
		p2_node.global_position = spawn_p2.global_position
		p2_node.velocity = Vector2.ZERO
	
	
	var viewport = get_node("SubViewport")
	for child in viewport.get_children():
		child.free()
	
	old_camera.enabled = true
	
	current_minigame = null

class Minigame:
	var name: String
	var id: String
	var include_players: bool
	var scenes: Array

func _ready():
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
		load_minigame(minigames[0], 0)
	elif Input.is_action_just_pressed("ui_down"):
		unload_minigame()
