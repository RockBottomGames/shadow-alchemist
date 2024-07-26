extends ParticleColliderObject
class_name ShadowOilParticleCollider

const COLLIDER_SIZE: float = 16.0

func _init(
	transform2D: Transform2D = Transform2D.IDENTITY,
	world_space: RID = RID(),
	parent_canvas_item_rid: RID = RID(),
	texture: Texture = null,
	new_texture_size: float = 2.0
) -> void:
	var collision_layer_bitmask = 32
	var collision_mask_bitmask = 40
	super(transform2D, world_space, COLLIDER_SIZE, collision_layer_bitmask, collision_mask_bitmask,parent_canvas_item_rid, new_texture_size, texture, Color("ff00ff"), 2)
