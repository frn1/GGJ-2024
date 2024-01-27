extends CharacterBody2D

#@export var enabled = true

@export var player_number = 1

@export var speed = 500.0
@export var jump_velocity = -850.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#if enabled == false:
		#return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(Controller.format_action_id("action", player_number)) and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis(Controller.format_action_id("left", player_number), Controller.format_action_id("right", player_number))
	velocity.x = speed * direction

	move_and_slide()
