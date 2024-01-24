extends Sprite2D

@export_enum("Rock", "Paper", "Sissors") var choice

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(get_local_mouse_position()):
			get_parent().choice_made(choice)
