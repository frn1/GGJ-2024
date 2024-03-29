extends Area2D

@export var speed = 600
@export var direction = Vector2(1,0)

func _ready():
	body_entered.connect(func(body):
		body.add_score.call()
		body.queue_free()
		queue_free()
	)
	$Sprite2D.flip_h = direction.x > 0

func _process(delta):
	position += direction * speed * delta
	
