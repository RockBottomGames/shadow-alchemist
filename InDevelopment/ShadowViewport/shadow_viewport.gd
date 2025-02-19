extends MarginContainer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var camera_2d: Camera2D = $SubViewportContainer/SubViewport/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d
	if Globals.camera != null:
		camera_2d.global_position = Globals.camera.global_position
		camera_2d.offset = Globals.camera.offset
		camera_2d.drag_vertical_offset = Globals.camera.drag_vertical_offset
		camera_2d.drag_horizontal_offset = Globals.camera.drag_horizontal_offset
		camera_2d.position_smoothing_enabled = Globals.camera.position_smoothing_enabled
		camera_2d.position_smoothing_speed = Globals.camera.position_smoothing_speed
		camera_2d.reset_smoothing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.camera != null:
		camera_2d.global_position = Globals.camera.global_position
		camera_2d.offset = Globals.camera.offset
		camera_2d.drag_vertical_offset = Globals.camera.drag_vertical_offset
		camera_2d.drag_horizontal_offset = Globals.camera.drag_horizontal_offset
