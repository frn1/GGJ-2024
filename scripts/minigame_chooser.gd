extends Node2D

@export var spin_speed = 1400
@export var spin_time = 2

var speed_mul: float = 1

var spinning: bool = false

func get_time_secs() -> float:
	return Time.get_ticks_usec() / 1e+6

@onready var screen: Sprite2D = $Screen
@onready var size = screen.get_rect().size

@export var button_texture: Texture = preload("res://textures/In-between/Minigame chooser/button.png")
@export var button_pressed_texture: Texture = preload("res://textures/In-between/Minigame chooser/button pressed.png")

const Minigame = preload("res://scripts/minigame.gd")

var minigames: Array[Minigame.Minigame]

func load_minigames(minigame_list: Array[Minigame.Minigame]):
	if minigames && minigames.size() != 0:
		minigames.clear()
	minigames = minigame_list.duplicate()
	# Duplicate everything to make it seem more full
	for i in range(0, minigame_list.size()):
		minigames.push_back(minigame_list[i])
	seed(Time.get_unix_time_from_system() * 874)
	minigames.shuffle()

func generate_nodes():
	for connection in $Area2D.area_entered.get_connections():
		$Area2D.area_entered.disconnect(connection["callable"])
	$Area2D.area_entered.connect(
		func(area: Area2D):
			if area.has_meta("id"):
				selected_id = area.get_meta("id")
				print_rich(selected_id)
	)
	$Button.texture = button_texture
	for child in $Screen.get_children(true):
		$Screen.remove_child(child)
		child.queue_free()
	var nodes = []
	var label_settings = LabelSettings.new()
	label_settings.font_color = Color.BLACK
	label_settings.font_size = 40
	var minigame_height = size.y / minigames.size()
	for i in range(0, minigames.size()):
		var minigame = minigames[i]
		
		var node = Area2D.new()
		node.position.x = -size.x / 2
		node.position.y = minigame_height * i - size.y / 2
		node.set_meta("id", minigame.id)
		
		var label = Label.new()
		label.text = minigame.name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.set_meta("id", minigame.id)
		label.size.x = size.x
		label.size.y = minigame_height
		label.label_settings = label_settings
		
		var top_line = ColorRect.new()
		top_line.position.x = 0
		top_line.position.y = 0
		top_line.size.x = size.x
		top_line.size.y = 5
		top_line.color = Color.BLACK
		
		var bottom_line = top_line.duplicate()
		bottom_line.position.y = minigame_height
		
		var collision_shape_node = CollisionShape2D.new()
		var rect = Rect2(size.x / 2, minigame_height / 2, size.x, minigame_height)
		var shape = RectangleShape2D.new()
		shape.size = rect.size
		collision_shape_node.position = rect.position
		collision_shape_node.shape = shape
		
		var percent_completed = remap(node.position.y + size.y / 2, 0, size.y, 0, 1)
		if percent_completed < 0.15:
			node.modulate.a = remap(percent_completed, 0.0, 0.15, 0.0, 1.0)
		elif percent_completed > 0.6:
			node.modulate.a = remap(percent_completed, 0.6, 0.8, 1.0, 0.0)
		else:
			node.modulate.a = 1
		
		node.add_child(label)
		node.add_child(top_line)
		node.add_child(collision_shape_node)
		nodes.push_back(node)
	seed(round(Time.get_ticks_usec() * 100))
	nodes.shuffle()
	
	for node in nodes:
		$Screen.add_child(node)

var enabled = true

func start_spin():
	if spinning == true:
		push_error("Attempted to start spin animation while still spinning")
		return
	spinning = true
	$"jackpot arrancando".play()
	enabled = false
	$Button.texture = button_pressed_texture
	speed_mul = 1.0
	seed(round(Time.get_ticks_usec() * 100))
	get_tree().create_timer(4.5).timeout.connect(
		func():
			$"jackpot terminando".play()
			$"jackpot arrancando".stop()
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			tween.tween_property(self, "speed_mul", 0.0, 1.0)
			tween.finished.connect(
				func():
					spinning = false
					get_tree().create_timer(0.5).timeout.connect(
						func():
							var chosen_index = range(0, minigames.size()).reduce(
								func (acc: int, index: int):
									if minigames[index].id == selected_id:
										return index
									else:
										return acc
									)
							var minigame = minigames[chosen_index]
							get_parent().load_minigame(minigame)
							minigames.remove_at(chosen_index)
							if minigames.size() < 3:
								load_minigames(get_parent().minigames)
					)
			)
	)

var selected_id

func _ready():
	$Button.texture = button_pressed_texture
	await get_tree().create_timer(2.0).timeout
	$Button.texture = button_texture
	pass # Replace with function body.

func _input(event):
	if Input.is_anything_pressed():
		$Button.texture = button_pressed_texture
		if enabled == true:
			$boton.play()
			start_spin()
	else:
		$Button.texture = button_texture

func _process(delta):
	var height = size.y
	if spinning:
		for child in $Screen.get_children():
			child.position.y += delta * spin_speed * speed_mul
			child.position.y = fposmod(child.position.y + height / 2, height) - height / 2
			var percent_completed = remap(child.position.y + height / 2, 0, height, 0, 1)
			if percent_completed < 0.15:
				child.modulate.a = remap(percent_completed, 0.0, 0.15, 0.0, 1.0)
			elif percent_completed > 0.6:
				child.modulate.a = remap(percent_completed, 0.6, 0.8, 1.0, 0.0)
			else:
				child.modulate.a = 1
			#print(child.position.y)
