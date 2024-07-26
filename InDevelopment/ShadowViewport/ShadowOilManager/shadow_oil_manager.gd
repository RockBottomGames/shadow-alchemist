extends Node2D
class_name ShadowOilManager

@export var particle_texture: Texture
@export var max_shadow_oil_particles: int = 1000
var _current_shadow_oil_particles: int = 0

const MAX_SHADOW_PARTICLE_SIZE: float = 64.0
const MIN_SHADOW_PARTICLE_SIZE: float = 2.0

var _shadow_oil_particle_colliders: Dictionary = {}
var _deleted_shadow_oil_particle_colliders: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.shadow_oil_manager = self

func _physics_process(delta: float) -> void:
	for key: RID in _shadow_oil_particle_colliders:
		var shadow_oil_particle_collider = _shadow_oil_particle_colliders[key]
		shadow_oil_particle_collider.physics_process(delta, global_position)
		
	for key: RID in _deleted_shadow_oil_particle_colliders:
		var shadow_oil_particle_collider = _deleted_shadow_oil_particle_colliders[key]
		shadow_oil_particle_collider.physics_process(delta, global_position)
		
var tweens: Dictionary = {}

func _free_tween(collider_rid: RID):
	tweens.erase(collider_rid)

func resize_animate_particle(collider_rid: RID, new_size: float, shadow_particle: ShadowOilParticleCollider = null) -> Tween:
	if shadow_particle == null:
		shadow_particle = _shadow_oil_particle_colliders[collider_rid]
	if tweens.has(collider_rid):
		tweens[collider_rid].kill() # Abort the previous animation.
	var tween = create_tween()
	tween.tween_property(shadow_particle, "texture_size", new_size, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_free_tween.bind(collider_rid))
	tweens[collider_rid] = tween
	return tween

func add_shadow_oil(parent_global_position: Vector2):
	if (_current_shadow_oil_particles >= max_shadow_oil_particles):
		return
	_current_shadow_oil_particles += 1
	var placement_transform =  Transform2D(global_transform)
	placement_transform.origin = parent_global_position
	var particle_collider = ShadowOilParticleCollider.new(placement_transform, get_world_2d().space, get_canvas_item(), particle_texture, MIN_SHADOW_PARTICLE_SIZE)
	var collider_rid = particle_collider.get_key()
	_shadow_oil_particle_colliders[collider_rid] = particle_collider
	resize_animate_particle(collider_rid, MAX_SHADOW_PARTICLE_SIZE, particle_collider)

func get_shadow_oil_particle_collider(collider_rid: RID) -> ShadowOilParticleCollider:
	if _shadow_oil_particle_colliders.has(collider_rid):
		return _shadow_oil_particle_colliders[collider_rid]
	return null

func free_shadow_oil(shadow_oil_particle_collider: ShadowOilParticleCollider):
	_deleted_shadow_oil_particle_colliders.erase(shadow_oil_particle_collider.get_key())
	shadow_oil_particle_collider.free_rids()

func remove_shadow_oil(collider_rid: RID) -> bool:
	var particle_collider_to_remove: ShadowOilParticleCollider = get_shadow_oil_particle_collider(collider_rid)
	if particle_collider_to_remove != null:
		_deleted_shadow_oil_particle_colliders[collider_rid] = particle_collider_to_remove
		resize_animate_particle(collider_rid, MIN_SHADOW_PARTICLE_SIZE, particle_collider_to_remove).tween_callback(free_shadow_oil.bind(particle_collider_to_remove))
		_current_shadow_oil_particles -= 1
		return _shadow_oil_particle_colliders.erase(collider_rid)
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _exit_tree() -> void:
	Globals.shadow_oil_manager = null
