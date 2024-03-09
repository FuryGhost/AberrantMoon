extends CharacterBody2D

# Constants
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
const JUMP_BOOST_SPEED = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Private variables
var _jump_boost_direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope = true
	floor_constant_speed = true
	floor_snap_length = 10.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
		
		if direction == _jump_boost_direction:
			velocity.x += direction * JUMP_BOOST_SPEED
		else:
			_jump_boost_direction = 0
		
		$AnimatedSprite2D.flip_h = direction < 0;
		$AnimatedSprite2D.play("run")
	else:
		if is_on_floor():
			velocity.x = 0
			$AnimatedSprite2D.play("default_sitting")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
		_jump_boost_direction = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		if direction:
			velocity.x += direction * JUMP_BOOST_SPEED
			_jump_boost_direction = direction
	
	if !is_on_floor():
		if velocity.y > -100 && velocity.y < 100:
			$AnimatedSprite2D.play("mid_jump")
		elif velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	
	move_and_slide()
