extends Node2D

signal in_moon_sight
signal out_moon_sight


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_moon_hit_area_body_entered(body):
	in_moon_sight.emit()


func _on_moon_hit_area_body_exited(body):
	out_moon_sight.emit()
