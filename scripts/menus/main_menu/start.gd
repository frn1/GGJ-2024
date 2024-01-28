extends Button

func _ready():
	grab_focus()

var game = preload("res://scenes/game.tscn")

func _pressed():
	get_node("/root/Main menu").to_scene(game)
