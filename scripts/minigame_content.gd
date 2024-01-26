extends Node2D

const Minigame = preload("res://scripts/minigame.gd")

func end_minigame(end_state: Minigame.MinigameEndState):
	get_parent().end_minigame.emit(end_state)
	get_parent().unload_minigame()
