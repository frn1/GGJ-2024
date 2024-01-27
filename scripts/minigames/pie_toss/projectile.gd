extends CharacterBody2D

@export var speed = 20
@export var life_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(life_time).timeout.connect(
		queue_free
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2(cos(global_rotation - PI / 2), sin(global_rotation - PI / 2)) * speed
	var collision = move_and_collide(velocity)
	if collision:
		var is_bullet = collision.get_collider().get_script() == get_script()
		if is_bullet:
			return
