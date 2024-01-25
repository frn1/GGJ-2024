extends Node2D

@export_node_path("Sprite2D") var won = NodePath("Won")
@export_node_path("Sprite2D") var tie = NodePath("Tie")
@export_node_path("Sprite2D") var lost = NodePath("Lost")

var opponent = randi_range(0, 2)
var choice_processed = false

const Minigame = preload("res://scripts/minigame.gd")

func choice_made(choice):
	if choice_processed == false:
		choice_processed = true
		print("Opponent chose: " + str(opponent))
		if choice == opponent:
			get_node(tie).show()
			get_tree().create_timer(1.85).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.Tie))
		
		match choice:
			0:
				match opponent:
					1: 
						get_node(lost).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P2Won))
					2: 
						get_node(won).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P1Won))
			1:
				match opponent:
					0: 
						get_node(won).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P1Won))
					2: 
						get_node(lost).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P2Won))
			2:
				match opponent:
					0: 
						get_node(lost).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P2Won))
					1: 
						get_node(won).show()
						get_tree().create_timer(3.0).timeout.connect(func (): get_parent().end_minigame(Minigame.MinigameEndState.P1Won))
		
		
