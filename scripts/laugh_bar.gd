extends Panel

var points: float = 0.0 

@onready var filling = $Filling

func change_points(new_points: float):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "points", new_points, 0.45)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	filling.scale.x = remap(points, 0, 100, 0, 1)
	pass
