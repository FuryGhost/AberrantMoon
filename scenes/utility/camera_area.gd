extends Area2D

# Signals
signal camera_move(new_position: Vector2)

# @onready variables
@onready var camera_position: Vector2 = $CameraPosition.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	camera_move.emit(camera_position)
