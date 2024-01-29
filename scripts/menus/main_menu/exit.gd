extends Button

func _on_focus_entered():
	%"Tick sound".play()

func _pressed():
	get_tree().quit()

func _ready():
	if OS.has_feature("web"):
		queue_free()




