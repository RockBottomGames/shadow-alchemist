@tool
extends Area2D
class_name ShadowCollectionArea
signal on_shadow_oil_collection

@onready var suction_area: ShadowSuctionArea = $SuctionArea
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _queued_redraw = true
var _is_collecting : bool = false
var is_collecting : bool:
	get:
		return _is_collecting
	set(new_is_collecting):
		if _is_collecting == new_is_collecting:
			return
		_is_collecting = new_is_collecting
		_queued_redraw = true

var _collection_radius: float = 50.0
@export var collection_radius: float:
	get:
		return _collection_radius
	set(new_collection_radius):
		if _collection_radius == new_collection_radius:
			return
		_collection_radius = new_collection_radius
		_queued_redraw = true

var _suction_radius: float = 100.0
@export var suction_radius : float:
	get:
		return _suction_radius
	set(new_suction_radius):
		if _suction_radius == new_suction_radius:
			return
		_suction_radius = new_suction_radius
		_queued_redraw = true
		
var _suction_spread : float = 15.0
@export var suction_spread : float:
	get:
		return _suction_spread
	set(new_suction_spread):
		if _suction_spread == new_suction_spread:
			return
		_suction_spread = new_suction_spread
		_queued_redraw = true

func redraw():
	if suction_area == null or collision_shape_2d == null or !_queued_redraw:
		return
	_queued_redraw = false
	var is_disabled = !is_collecting
	if collision_shape_2d.disabled != is_disabled:
		collision_shape_2d.set_deferred("disabled", is_disabled)
	if collision_shape_2d.shape.radius != _collection_radius:
		collision_shape_2d.shape.set_deferred("radius", _collection_radius)
	suction_area.is_collecting = is_collecting
	suction_area.radius = suction_radius
	suction_area.spread = suction_spread
	suction_area.redraw()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func point_to_global_position(global_position: Vector2):
	suction_area.point_to_global_position(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _queued_redraw:
		redraw()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	Globals.shadow_oil_manager.remove_shadow_oil(body_rid)
	on_shadow_oil_collection.emit()
