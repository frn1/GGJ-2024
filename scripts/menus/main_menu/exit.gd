extends Button

func _pressed():
	get_tree().quit()

func _ready():
	if OS.has_feature("web"):
		queue_free()
