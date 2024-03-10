extends Node


# @onready variables
@onready var camera: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Make proper close screen
	if (Input.is_action_pressed("ui_cancel")):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()


func _on_level_camera_move(new_position):
	camera.position = new_position
