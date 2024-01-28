extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("/root/Curtain") != null:
		var viewport_rect = get_viewport_rect()
		var curtain = get_node("/root/Curtain")
		curtain.position.x += viewport_rect.size.x / 2
		curtain.position.y += viewport_rect.size.y / 2
		var tween = create_tween()
		var new_pos = curtain.global_position
		new_pos.y = -900
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(curtain, "global_position", new_pos, 0.5)
		tween.finished.connect(
			func():
				await get_tree().create_timer(0.1).timeout
				$"Animation thingy".process_mode = Node.PROCESS_MODE_INHERIT
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
