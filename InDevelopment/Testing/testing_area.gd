extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().canvas_cull_mask = 1
	pass # Replace with function body.
	
	
# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


var title = "Game v0.1"

func _process(_delta):
	DisplayServer.window_set_title("FPS %d" % Engine.get_frames_per_second())
