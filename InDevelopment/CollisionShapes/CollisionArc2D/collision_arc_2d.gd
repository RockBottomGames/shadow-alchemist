@tool
extends CollisionPolygon2D
class_name CollisionArc2D

const _ADD_POINT_EVERY_N_DEGREES: float = deg_to_rad(15.0)

var _queued_redraw: bool = true
var _radius: float = 400.0
@export var radius : float:
	get:
		return _radius
	set(new_radius):
		if new_radius == _radius:
			return
		_radius = new_radius
		_queued_redraw = true

var _spread: float = deg_to_rad(30.0)
@export var spread : float:
	get:
		return rad_to_deg(_spread)
	set(new_spread):
		var new_rads_spread = deg_to_rad(new_spread)
		if new_rads_spread == _spread:
			return
		_spread = new_rads_spread
		_queued_redraw = true

func redraw():
	if !_queued_redraw:
		return
	_queued_redraw = false
	var new_polygon = polygon
	new_polygon.clear()
	# set origin first
	new_polygon.append(Vector2.ZERO)
	var distance = Vector2(_radius, 0)
	# 31 spread with 15 degree points should be (ceiling of 31/15) so 3
	var arc_point_loop_count: int = ceili(_spread / _ADD_POINT_EVERY_N_DEGREES)
	var degree_diff: float = _spread / float(arc_point_loop_count)
	var currentPoint = distance.rotated(_spread / -2.0)
	new_polygon.append(currentPoint)
	for n in arc_point_loop_count:
		currentPoint = currentPoint.rotated(degree_diff)
		new_polygon.append(currentPoint)
	set_deferred("polygon", new_polygon)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _queued_redraw:
		redraw()
