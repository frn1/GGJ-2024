extends Panel

var points: float = 0.0 
var shown_points: float = 0.0 

@onready var filling = $Filling

func update_bar():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "shown_points", points, 0.45)
	randomize()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	filling.scale.x = remap(shown_points, 0, 100, 0, 1)
	pass
