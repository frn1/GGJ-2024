extends Button

func _ready():
	grab_focus()
	focus_entered.connect(%"Tick sound".play)

var game = preload("res://scenes/game.tscn")

func _pressed():
	$"Start sound".play()
	$"Start sound".finished.connect(queue_free)
	$"Start sound".reparent(get_tree().root)
	get_node("/root/Main menu").to_scene(game)

