extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("/root/Curtain") != null:
		var viewport_rect = get_viewport_rect()
		var curtain = get_node("/root/Curtain")
		var tween = create_tween()
		var new_pos = curtain.global_position
		new_pos.y = -900
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(curtain, "global_position", new_pos, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
