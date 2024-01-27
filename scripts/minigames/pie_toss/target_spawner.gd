extends Node2D

@export var target: PackedScene
@export var rate: float = 0.2
@export var speed: float = 600
@export var direction: Vector2 = Vector2.RIGHT
@export_range(0, 100, 0.1) var chance: float = 70

# Raise the chances if one hasn't spawned in a while
var times_not_spawned = 0

func timer_timeout():
	get_tree().create_timer(rate).timeout.connect(
		timer_timeout
	)
	if randf() > (chance + times_not_spawned * 3.5) / 100:
		times_not_spawned += 1
		return
	else:
		randomize()
		times_not_spawned = 0
	var target_node = target.instantiate()
	target_node.direction = direction
	target_node.global_position = global_position
	target_node.speed = speed
	get_parent().add_child.call_deferred(target_node)

func _ready():
	timer_timeout()
