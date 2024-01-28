extends Area2D

@export_enum("No player", "Player 1", "Player 2") var player_that_loses = 1

const Minigame = preload("res://scripts/minigame.gd")

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		match player_that_loses:
			1:
				get_parent().get_parent().end_minigame(Minigame.MinigameEndState.P2Won)
			2:
				get_parent().get_parent().end_minigame(Minigame.MinigameEndState.P1Won)

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
