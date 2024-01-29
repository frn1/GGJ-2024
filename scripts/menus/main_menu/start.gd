extends Button

func _ready():
	grab_focus()
	focus_entered.connect(%"Tick sound".play)

var game = load("res://scenes/game.tscn")

func _pressed():
	var tween = create_tween()
	tween.tween_property(get_node("/root/BGM"), "volume_db", -80, 3)
	tween.finished.connect(get_node("/root/BGM").queue_free)
	$"Start sound".play()
	$"Start sound".finished.connect(queue_free)
	$"Start sound".reparent(get_tree().root)
	get_node("/root/Main menu").to_scene(game)

