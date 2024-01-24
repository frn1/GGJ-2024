extends Node2D

@export_node_path("Sprite2D") var won = NodePath("Won")
@export_node_path("Sprite2D") var tie = NodePath("Tie")
@export_node_path("Sprite2D") var lost = NodePath("Lost")

var opponent = randi_range(0, 2)
var choice_processed = false

func choice_made(choice):
	if choice_processed == false:
		choice_processed = true
		print("Opponent chose: " + str(opponent))
		if choice == opponent:
			get_node(tie).show()
		match choice:
			0:
				match opponent:
					1: 
						get_node(lost).show()
					2: 
						get_node(won).show()
			1:
				match opponent:
					0: 
						get_node(won).show()
					2: 
						get_node(lost).show()
			2:
				match opponent:
					0: 
						get_node(lost).show()
					1: 
						get_node(won).show()
