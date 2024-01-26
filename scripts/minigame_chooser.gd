extends Control

@export var time_taken_to_complete_loop = 0.25

var speed_mul: float

@onready var options = $Panel/Options
@onready var number_of_options

var spinning: bool = false
var options_children: Array

func get_time_secs() -> float:
	return Time.get_ticks_usec() / 1e+6

func start_spin():
	if spinning == true:
		push_error("Attempted to start spin animation while still spinning")
		return
	spinning = true
	speed_mul = 1.5
	options_children = options.get_children()
	number_of_options = options_children.size()
	var label_height = options_children.reduce(
		func (accum, label):
			var height = label.get_line_height()
			if height > accum: 
				return height
			else: 
				return accum
			, 0.0)
	var height = options.size.y - label_height
	for i in range(0, options_children.size()):
		var child = options_children[i]
		child.modulate.a = 1
		child.position.y = (height / number_of_options) * i
		randomize()
		get_tree().create_timer(randf_range(2.5, 3.8)).timeout.connect(
		func():
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
			tween.tween_property(self, "speed_mul", 0.0, 3)
			tween.finished.connect(
				func():
					spinning = false
					var selected_id = options_children.reduce(
						func(acc: Label, label: Label):
							var middle = options.size.y / 2
							if label.position.y < middle && label.get_line_height() + label.position.y > middle:
								return label
							return acc
					).get_meta("id")
					var parent = get_parent()
					parent.load_minigame(
					parent.minigames.reduce(
						func(acc, minigame):
							if minigame.id == selected_id:
								return minigame
							return acc
					))
			)
	)

func _ready():
	$Button.pressed.connect(start_spin)
	pass # Replace with function body.

func _process(delta):
	if spinning:
		var label_height = options_children.reduce(
			func (accum, label):
				var height = label.get_line_height()
				if height > accum: 
					return height
				else: 
					return accum
				, 0.0)
		var height = options.size.y - label_height
		for i in range(0, number_of_options):
			var child = options_children[i]
			child.position.y += (delta / time_taken_to_complete_loop) * height * speed_mul
			child.position.y = fposmod(child.position.y, height)
