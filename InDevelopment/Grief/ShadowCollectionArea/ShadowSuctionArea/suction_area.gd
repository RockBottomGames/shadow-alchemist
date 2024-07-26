@tool
extends Area2D
class_name ShadowSuctionArea

@onready var collision_arc_2d: CollisionArc2D = $CollisionArc2D

var _shadow_oil_being_pulled: Dictionary = {}
var _direction: Vector2 = Vector2(-1, 0)
var _power: float = 200

var _queued_redraw = true
var _is_collecting = false
@export var is_collecting : bool:
	get:
		return _is_collecting
	set(new_is_collecting):
		if _is_collecting == new_is_collecting:
			return
		_is_collecting = new_is_collecting
		_queued_redraw = true

var _radius : float = 100.0
@export var radius : float:
	get:
		return _radius
	set(new_radius):
		if new_radius == _radius:
			return
		_radius = new_radius
		_queued_redraw = true

var _spread : float = 15.0
@export var spread : float:
	get:
		return _spread
	set(new_spread):
		if new_spread == _spread:
			return
		_spread = new_spread
		_queued_redraw = true

func redraw():
	if collision_arc_2d == null or !_queued_redraw:
		return
	_queued_redraw = false
	if collision_arc_2d.disabled != !is_collecting:
		collision_arc_2d.set_deferred("disabled", !is_collecting)
	collision_arc_2d.radius = radius
	collision_arc_2d.spread = spread
	collision_arc_2d.redraw()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _queued_redraw:
		redraw()

func _physics_process(delta: float) -> void:
	for key in _shadow_oil_being_pulled:
		var shadow_oil: ShadowOilParticleCollider = _shadow_oil_being_pulled[key]
		if shadow_oil != null:
			var location = shadow_oil.getLocation(global_position)
			var direction = -location
			shadow_oil.applyForce(direction.normalized() * _power)

func point_to_global_position(global_position: Vector2):
	var local_position = to_local(global_position)
	rotate(local_position.angle())
	pass

func add_shadow_oil(shadow_oil_collider_rid: RID):
	_shadow_oil_being_pulled[shadow_oil_collider_rid] = Globals.shadow_oil_manager.get_shadow_oil_particle_collider(shadow_oil_collider_rid)

func remove_shadow_oil(shadow_oil_collider_rid: RID):
	_shadow_oil_being_pulled.erase(shadow_oil_collider_rid)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	add_shadow_oil(body_rid)


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	remove_shadow_oil(body_rid)
