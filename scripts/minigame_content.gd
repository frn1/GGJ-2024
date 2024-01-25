extends Node2D

const Minigame = preload("res://scripts/minigame.gd")

func end_minigame(end_state: Minigame.MinigameEndState):
	get_parent().end_minigame.emit(end_state)
	get_parent().unload_minigame()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
