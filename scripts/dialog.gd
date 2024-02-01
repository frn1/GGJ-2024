extends Node2D

@export var original_time_per_character: float = 0.0225
var time_per_character: float = original_time_per_character

var message = ""

var waiting = false
var writing_message: bool = false
var start: float = 0.0

func write(text: String):
	time_per_character = original_time_per_character
	start = Time.get_ticks_msec() / 1000.0
	message = text.strip_edges()
	writing_message = true
	
func write_append(text: String):
	message += " " + text.strip_edges()
	writing_message = true

var ink_player: InkPlayer = InkPlayerFactory.create()

signal message_finished
signal pressed_continue
signal can_continue

func appear(duration: float = 0.5) -> Tween:
	$Text.text = ""
	var new_modulate = modulate
	new_modulate.a = 1
	modulate.a = 0
	show()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", new_modulate, duration)
	return tween

func dissapear(duration: float = 0.5) -> Tween:
	var new_modulate = modulate
	new_modulate.a = 0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", new_modulate, duration)
	return tween

func change_expression(expression: String):
	var path = "res://textures/Dialog/%s.png" % expression
	if ResourceLoader.exists(path):
		$Expression.texture = load(path)
	else:
		$Expression.texture = null

var should_continue_story = true

func wait(seconds: float):
	waiting = true
	should_continue_story = false
	get_tree().create_timer(seconds).timeout.connect(
		func():
			start += seconds
			waiting = false
			should_continue_story = true
			can_continue.emit()
	)

func play_sound(name: String, wait: bool = true):
	if wait:
		waiting = true
		should_continue_story = false
	var player = AudioStreamPlayer.new()
	player.volume_db = -15
	player.stream = load("res://sounds/Sound Effects/Story Scene/".path_join(name))
	player.finished.connect(
		func():
			if wait:
				start += player.stream.get_length()
				waiting = false
				should_continue_story = true
				can_continue.emit()
			player.queue_free()
	)
	add_child(player)
	player.play()

func show_icons(): 
	$"Continue Icons".show()
	$"Continue Icons".modulate.a = 0
	var tween = create_tween()
	tween.tween_property($"Continue Icons", "modulate", Color.WHITE, 0.25)

# Called when the node enters the scene tree for the first time.
func play(data: InkResource):
	show()
	ink_player.ink_file = data
	ink_player.stop_execution_on_error = false
	ink_player.create_story()
	await ink_player.loaded
	ink_player.bind_external_function("cambiar_expresion", self, "change_expression", false)
	ink_player.bind_external_function("esperar", self, "wait", false)
	ink_player.bind_external_function("reproducir_sonido", self, "play_sound", false)
	while ink_player.can_continue && should_continue_story:
		write(ink_player.continue_story())
		while ink_player.current_tags.has("continue"):
			await message_finished
			if waiting:
				await can_continue
			write_append(ink_player.continue_story())
		await message_finished
		show_icons()
		await pressed_continue
	ink_player.unbind_external_function("cambiar_expresion")
	ink_player.unbind_external_function("esperar")
	ink_player.unbind_external_function("reproducir_sonido")

func _ready():
	ink_player.loads_in_background = true
	add_child(ink_player)

func _input(event: InputEvent):
	if Input.is_anything_pressed():
		if writing_message:
			time_per_character /= 2
		pressed_continue.emit()
		var tween = create_tween()
		tween.tween_property($"Continue Icons", "modulate", Color.TRANSPARENT, 0.25)

func _process(delta):
	if writing_message && !waiting:
		var time = Time.get_ticks_msec() / 1000.0 - start
		var length = time / time_per_character
		$Text.text = message.substr(0, length)
		if length >= message.length():
			writing_message = false
			message_finished.emit()
