extends Button

var changing = false

func _ready():
	grab_focus()
	focus_entered.connect(%"Tick sound".play)

var game = preload("res://scenes/game.tscn")

func _pressed():
	if changing == true:
		return
	changing = true
	var sound = $"Start sound"
	var tween = get_tree().root.create_tween()
	tween.tween_property(get_node("/root/BGM"), "volume_db", -80, 3)
	tween.tween_property(sound, "volume_db", -90, 1.5)
	tween.finished.connect(
		func():
			get_node("/root/BGM").stop()
			get_node("/root/BGM").queue_free()
	)
	sound.play()
	sound.reparent(get_tree().root)
	sound.finished.connect(queue_free)
	get_node("/root/Main menu").to_scene(game)

