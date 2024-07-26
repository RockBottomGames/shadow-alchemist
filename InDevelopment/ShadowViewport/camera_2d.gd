extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_smoothing_enabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(Globals.camera):
		global_position = Globals.camera.global_position
		zoom = Globals.camera.zoom
		set_deferred("position_smoothing_enabled", true)
	pass
