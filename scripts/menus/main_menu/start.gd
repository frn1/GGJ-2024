extends Button

func _ready():
	grab_focus()

var game = preload("res://scenes/game.tscn")

func _pressed():
	var curtain = %Curtain
	curtain.reparent(get_node("/root"))
	var viewport_rect = get_viewport_rect()
	var new_pos = curtain.global_position
	new_pos.y = 100
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(curtain, "position", new_pos, 0.8)
	tween.finished.connect(
		func():
			get_tree().change_scene_to_packed(game)
	)
	print("Start")
