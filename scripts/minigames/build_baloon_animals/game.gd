extends Node2D

enum Buttons {
	Left,
	Right,
	Up,
	Down,
	A_Space
}

var actions: Array[Buttons]

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(0, rng.randi_range(6, 8)):
		# Gives A/Space a slightly higher chance
		var button_chosen = clamp(rng.randi_range(0, Buttons.size()), 0, Buttons.size() - 1)
		if button_chosen == Buttons.A_Space:
			rng.randomize()
		actions.push_back(button_chosen)
	print(actions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
