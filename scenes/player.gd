extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -550.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		if is_on_floor():
			velocity.x = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
