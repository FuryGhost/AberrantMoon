extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

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
		$AnimatedSprite2D.flip_h = direction < 0;
		$AnimatedSprite2D.play("run")
	else:
		if is_on_floor():
			velocity.x = 0
			$AnimatedSprite2D.play("default_sitting")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	
	if !is_on_floor():
		if velocity.y > -100 && velocity.y < 100:
			$AnimatedSprite2D.play("mid_jump")
		elif velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	
	move_and_slide()
