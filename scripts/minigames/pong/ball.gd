extends CharacterBody2D

@export var speed = 400.0

var x_dir = -1
var direction: Vector2 = Vector2.ZERO

var bounces = 0

func _ready():
	get_tree().create_timer(1).timeout.connect(
		func():
			randomize()
			direction = Vector2.RIGHT
			if randf() < 0.5:
				x_dir = 1
			else:
				x_dir = -1
	)

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
	if collision:
		var collider = collision.get_collider()
		if collider is Node2D:
			direction = Vector2(x_dir, deg_to_rad(randf_range(20, 60)) * [-1, 1].pick_random())
			if collider.has_meta("is_player") && collider.get_meta("is_player"):
				x_dir = -x_dir
