extends Resource
class_name ParticleColliderObject

var _collider_rid: RID = RID()
var _particle_rid: RID = RID()
var _texture: Texture = null
var _node2D: Node2D = null
var _texture_size: float = 1.0
var texture_size : float:
	get:
		return _texture_size
	set(new_texture_size):
		if _texture_size == new_texture_size:
			return
		_texture_size = new_texture_size
		_resize()

func _init(
	transform2D: Transform2D = Transform2D.IDENTITY,
	world_space: RID = RID(),
	collider_size: float = 1.0,
	collision_layer_bitmask: int = 0,
	collision_mask_bitmask: int = 0,
	parent_canvas_item_rid: RID = RID(),
	texture_size: float = 1.0,
	texture: Texture = null,
	textureModulateColor: Color = Color(0.0, 0.0, 0.0, 0.0),
	visibility_layer_mask: int = 1,
) -> void:
	_texture = texture
	_texture_size = texture_size
	_create_collider(transform2D, world_space, collider_size, collision_layer_bitmask, collision_mask_bitmask)
	_create_particle(parent_canvas_item_rid, textureModulateColor, visibility_layer_mask)

func _sizeFloatToVector2(size: float) -> Vector2:
	return Vector2(size, size)

func get_key() -> RID:
	return _collider_rid

func _create_collider(transform2D: Transform2D, world_space: RID, size: float, collision_layer_bitmask: int, collision_mask_bitmask: int):
	_collider_rid = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(_collider_rid, PhysicsServer2D.BODY_MODE_RIGID)
	PhysicsServer2D.body_set_space(_collider_rid, world_space)
	var collision_circle = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(collision_circle, size)
	PhysicsServer2D.body_add_shape(_collider_rid, collision_circle, Transform2D.IDENTITY)
	PhysicsServer2D.body_set_collision_layer(_collider_rid, collision_layer_bitmask)
	PhysicsServer2D.body_set_collision_mask(_collider_rid, collision_mask_bitmask)

	PhysicsServer2D.body_set_param(_collider_rid, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE,0.0)
	PhysicsServer2D.body_set_param(_collider_rid, PhysicsServer2D.BODY_PARAM_LINEAR_DAMP,20.0)
	PhysicsServer2D.body_set_param(_collider_rid, PhysicsServer2D.BODY_PARAM_FRICTION,20.0)
	PhysicsServer2D.body_set_param(_collider_rid, PhysicsServer2D.BODY_PARAM_MASS, 0.05)
	PhysicsServer2D.body_set_state(_collider_rid, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2D)

func _set_size():
	var size_vector = _sizeFloatToVector2(_texture_size)
	var rect = Rect2((size_vector / -2.0), size_vector)
	RenderingServer.canvas_item_add_texture_rect(_particle_rid, rect, _texture)
	
	
func _create_particle(parent_canvas_item_rid: RID, textureModulateColor: Color, visibility_layer_mask: int):
	_particle_rid = RenderingServer.canvas_item_create()
	#RenderingServer.canvas_item_set_parent(_particle_rid, _collider_rid)
	if textureModulateColor.a != 0:
		RenderingServer.canvas_item_set_self_modulate(_particle_rid, textureModulateColor)
	RenderingServer.canvas_item_set_parent(_particle_rid, parent_canvas_item_rid)
	RenderingServer.canvas_item_set_visibility_layer(_particle_rid, visibility_layer_mask)
	_set_size()

func _resize():
	RenderingServer.canvas_item_clear(_particle_rid)
	_set_size()

func applyForce(force: Vector2):
	PhysicsServer2D.body_apply_central_force(_collider_rid, force)

func getTransform():
	return PhysicsServer2D.body_get_state(_collider_rid, PhysicsServer2D.BODY_STATE_TRANSFORM)

func getLocation(parent_global_position: Vector2, transform2D = null) -> Vector2:
	var previousTransform2D = getTransform()
	if previousTransform2D == null:
		return Vector2.ZERO
	var newTransform2D: Transform2D = Transform2D.IDENTITY
	if transform2D == null:
		newTransform2D = previousTransform2D
	else:
		newTransform2D = transform2D
	return newTransform2D.origin - parent_global_position

func physics_process(delta, parent_global_position):
	var transform2D = getTransform()
	if transform2D == null:
		return
	transform2D.origin = getLocation(parent_global_position, transform2D)
	RenderingServer.canvas_item_set_transform(_particle_rid, transform2D)

func free_rids():
	RenderingServer.free_rid(_particle_rid)
	PhysicsServer2D.free_rid(_collider_rid)
