extends Node2D

@export var time_per_character: float

var message = "Hola como estas"

var writing_message: bool = false
var start: float

signal message_finished
signal pressed_continue

func write_message(name: String, text: String, time_per_char = 0.025):
	start = Time.get_ticks_msec() / 1000.0
	writing_message = true
	message = text
	time_per_character = time_per_char

func change_expression(expression: String):
	$Expression.texture = load("res://textures/Dialog/%s.png" % expression)

func appear(duration: float = 0.5) -> Tween:
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

func run_line(record: Array):
	var command: String = record[0].to_lower().strip_edges()
	match command:
		"mensaje":
			write_message(record[1].strip_edges(), record[2].strip_edges())
			await message_finished
			if record[4].strip_edges().is_empty():
				await pressed_continue
		"esperar":
			await get_tree().create_timer(float(record[1])).timeout

# Called when the node enters the scene tree for the first time.
func play(data):
	modulate.a = 0
	show()
	$Text.text = ""
	await get_tree().create_timer(0.2).timeout
	modulate.a = 0
	await appear().finished
	for record in data.records:
		await run_line(record)
	#await dissapear().finished

func _ready():
	message_finished.connect(
		func():
			$"Continue Icons".show()
			$"Continue Icons".modulate.a = 0
			var tween = create_tween()
			tween.tween_property($"Continue Icons", "modulate", Color.WHITE, 0.25)
	)
	
	if Input.is_anything_pressed():
		pressed_continue.emit()

var character = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if writing_message:
		var time = Time.get_ticks_msec() / 1000.0 - start
		var length = min(time / time_per_character, message.length())
		if length == message.length():
			writing_message = false
			message_finished.emit()
		$Text.text = message.substr(0, length)
		character += 1
