extends Button

func _ready():
	grab_focus()

var game = preload("res://scenes/game.tscn")


func _on_mouse_entered():
	$HitSound.play()
func _on_focus_entered():
	$HitSound.play()

func _pressed():
	$AudioStreamPlayer2D.play()
	await $AudioStreamPlayer2D.finished
	get_node("/root/Main menu").to_scene(game)

