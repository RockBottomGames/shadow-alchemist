extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().canvas_cull_mask = 1
	pass # Replace with function body.

var title = "Game v0.1"

func _process(_delta):
	DisplayServer.window_set_title("FPS %d" % Engine.get_frames_per_second())
