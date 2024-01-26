extends Control

const DURATION: float = 0.5

var spinning = false

var options_children

func speen(node: Control, original_pos: Vector2):
	node.modulate.a = 0
	var new_modulate_mid = node.modulate
	new_modulate_mid.a = 1
	var new_modulate_end = node.modulate
	new_modulate_end.a = 0
	var tween_opacity = get_tree().create_tween()
	var tween = get_tree().create_tween()
	tween.tween_property(node, "position", Vector2(node.position.x, node.position.y + 80), DURATION)
	tween.finished.connect(
		func():
			get_tree().create_timer(((DURATION / 2.5) * options_children.size() + 0.5) / 2).timeout.connect(
				func():
					node.position = original_pos
					speen(node, original_pos)
			)
	)
	tween_opacity.tween_property(node, "modulate", new_modulate_mid, DURATION / 5)
	tween_opacity.finished.connect(
		func():
			get_tree().create_timer((DURATION / 5) * 3).timeout.connect(
				func():
					var tween_opacity_end = get_tree().create_tween()
					tween_opacity_end.tween_property(node, "modulate", new_modulate_end, DURATION / 5)
			)
	)
	

func start_spin():
	if spinning == true:
		push_error("Attempted to start spin animation while still spinning")
		return
	spinning = true
	options_children = $Panel/Options.get_children()
	for i in range(0, options_children.size()):
		var child = options_children[i]
		var timer = get_tree().create_timer((DURATION / 2.5) * i)
		timer.timeout.connect(
			func ():
				speen(child, child.position)
		)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(start_spin)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
