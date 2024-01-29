extends Button


func to_scene(scene: PackedScene):
	var viewport_rect = get_viewport_rect()
	var curtain = %Curtain
	if get_node_or_null("/root/Curtain") == null:
		curtain.reparent(get_node("/root"))
	else:
		curtain = get_node("/root/Curtain")
	var new_pos = curtain.global_position
	new_pos.y = 100
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(curtain, "position", new_pos, 0.8)
	tween.finished.connect(
		func():
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_packed(scene)
	)

# Called when the node enters the scene tree for the first time.
func _pressed():
	to_scene(preload("res://scenes/menus/main_menu.tscn"))
