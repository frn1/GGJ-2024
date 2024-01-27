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
			if collider.has_meta("is_player") && collider.get_meta("is_player"):
				bounces += 1
				speed += 40 - log(bounces) * 3
				speed = min(speed, 2000)
				x_dir = -x_dir
			direction = Vector2(x_dir, deg_to_rad(randf_range(30, 70)) * [-1, 1].pick_random()).normalized()
