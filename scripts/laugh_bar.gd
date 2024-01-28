extends Node2D

var points: float = 0.0 
var shown_points: float = 0.0 

@onready var filling = $Fill

@export var start_x: float = 195
@export var end_x: float = 500 + 195

func update_bar():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "shown_points", points, 0.45)
	seed(round(Time.get_unix_time_from_system() * 10))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	filling.region_rect.size.x = (shown_points / 100) * (end_x - start_x) + start_x
	pass
