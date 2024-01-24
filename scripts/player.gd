extends CharacterBody2D

#@export var enabled = true

@export var player_number = 1

@export var speed = 500.0
@export var jump_velocity = -810.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func format_action(action: String, player: int) -> String:
	return "p" + str(player) + " " + action

func _physics_process(delta):
	#if enabled == false:
		#return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(format_action("jump", player_number)) and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis(format_action("left", player_number), format_action("right", player_number))
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
