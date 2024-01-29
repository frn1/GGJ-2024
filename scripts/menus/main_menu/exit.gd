extends Button

func _on_mouse_entered():
	$HitSound.play()
	
func _on_focus_entered():
	$HitSound.play()
	
func _pressed():
	get_tree().quit()
	$AudioStreamPlayer2D.play()

func _ready():
	if OS.has_feature("web"):
		queue_free()




