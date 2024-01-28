extends Node

const Minigame = preload("res://scripts/minigame.gd")

func end_minigame(end_state: Minigame.MinigameEndState):
	get_parent().get_parent().get_parent().end_minigame.emit(end_state)
	get_parent().get_parent().get_parent().unload_minigame()
