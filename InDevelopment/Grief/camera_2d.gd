extends Camera2D

const _CAMERA_OFFSET_MAX_CUTOFF: float = 200.0
const _CAMERA_OFFSET_MIN_CUTOFF: float = 100.0

@export var camera_offset_max_distance: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.camera = self
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		var _mouse_camera_position = get_parent().get_local_mouse_position()
		var distance_modifier = (_mouse_camera_position.length() - _CAMERA_OFFSET_MIN_CUTOFF) / _CAMERA_OFFSET_MAX_CUTOFF
		if distance_modifier > 1.0:
			distance_modifier = 1.0
		if distance_modifier <= 0.0:
			position = Vector2.ZERO
			return
		position = _mouse_camera_position.normalized() * distance_modifier * camera_offset_max_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _exit_tree() -> void:
	Globals.camera = null
