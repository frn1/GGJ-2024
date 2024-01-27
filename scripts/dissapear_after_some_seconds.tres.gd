extends Sprite2D

@export var time = 7.5
@export var free_after_dissapearing = false

func _ready():
	get_tree().create_timer(time).timeout.connect(
		func():
			var new_modulate = modulate
			new_modulate.a = 0
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CIRC)
			tween.tween_property(self, "modulate", new_modulate, 0.5)
			if free_after_dissapearing:
				tween.finished.connect(
					func():
						self.queue_free()
				)
	)
