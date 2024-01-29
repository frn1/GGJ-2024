extends Button

func _ready():
	focus_entered.connect(%"Tick sound".play)

func to_scene(scene: PackedScene):
	var viewport_rect = get_viewport_rect()
	var curtain = get_node("/root/Curtain")
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

func _pressed():
	to_scene(load("res://scenes/menus/main_menu.tscn"))
