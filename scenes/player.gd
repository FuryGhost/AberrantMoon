extends CharacterBody2D

# Constants
const SPEED = 300.0
const CROUCH_SPEED = 100.0
const JUMP_VELOCITY = -800.0
const JUMP_BOOST_SPEED = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Private variables
var _jump_boost_direction = 0

# @onready variables
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sit_run_collision_shape: CollisionShape2D = $SitRunCollisionShape
@onready var crouch_collision_shape: CollisionShape2D = $CrouchCollisionShape

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_stop_on_slope = true
	floor_constant_speed = true
	floor_snap_length = 10.0


func _physics_process(delta):
	var on_floor: bool = is_on_floor()
	var direction: float = Input.get_axis("move_left", "move_right")
	var is_crouching: bool = Input.is_action_pressed("crouch") && on_floor
	
	_handle_gravity(delta, on_floor)
	
	_handle_horizontal_move(delta, on_floor, direction, is_crouching)
	
	_handle_jump(on_floor, direction)
	
	_handle_rotation(on_floor)
	
	_handle_animation(on_floor, direction, is_crouching)
	
	_handle_collision_shape(is_crouching)
	
	move_and_slide()

func _handle_gravity(delta: float, on_floor: bool):
	if not on_floor:
		velocity.y += gravity * delta

func _handle_horizontal_move(delta: float, on_floor: bool, direction: float, is_crouching: bool):
	if direction:
		if is_crouching:
			velocity.x = direction * CROUCH_SPEED
		else:
			velocity.x = direction * SPEED
		
		if direction == _jump_boost_direction && !on_floor:
			velocity.x += direction * JUMP_BOOST_SPEED
		else:
			_jump_boost_direction = 0
	else:
		if on_floor:
			velocity.x = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
		_jump_boost_direction = 0

func _handle_jump(on_floor: bool, direction: float):
	if Input.is_action_just_pressed("jump") and on_floor:
		velocity.y = JUMP_VELOCITY
		
		if direction:
			velocity.x += direction * JUMP_BOOST_SPEED
			_jump_boost_direction = direction

func _handle_rotation(on_floor: bool):
	if !on_floor:
		rotation = 0
	else:
		var rotation_direction = 1 if get_floor_normal().x >= 0 else -1
		rotation = get_floor_angle() * rotation_direction

func _handle_animation(on_floor: bool, direction: float, is_crouching: bool):
	if direction:
		animated_sprite.flip_h = direction < 0
	
	if is_crouching:
		if direction:
			animated_sprite.play("crouch")
		else:
			animated_sprite.stop()
			animated_sprite.animation = "crouch"
			animated_sprite.frame = 0
	elif on_floor:
		if direction:
			animated_sprite.play("run")
		else:
			animated_sprite.play("default_sitting")
	else:
		if velocity.y > -100 && velocity.y < 100:
			animated_sprite.play("mid_jump")
		elif velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func _handle_collision_shape(is_crouching: bool):
	sit_run_collision_shape.set_deferred("disabled", is_crouching)
	crouch_collision_shape.set_deferred("disabled", !is_crouching)
