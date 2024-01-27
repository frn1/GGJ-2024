extends CharacterBody2D

@export var speed = 400.0

var direction: Vector2 = Vector2.ZERO
var going_right = true

var bounces = 0

func _ready():
	get_tree().create_timer(1).timeout.connect(
		func():
			randomize()
			direction = Vector2.RIGHT
			going_right = randf() < 0.5
	)

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
	if collision:
		var collider = collision.get_collider()
		if collider is Node2D:
			var angle = direction.angle() - PI / 2
			angle += deg_to_rad(randf_range(30, 60)) * sign(angle)
			direction = Vector2.from_angle(angle)
