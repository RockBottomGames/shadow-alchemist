extends BaseCharacter
class_name TinySlenderShadow

@onready var recalculate_timer: Timer = $Navigation/RecalculateTimer
@onready var animation_tree: EnemyAnimationTree = $Sprite2D/AnimationTree
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _knockback_velocity = Vector2.ZERO

var is_dead : bool:
	get:
		return animation_tree.is_dead
	set(new_is_dead):
		animation_tree.is_dead = new_is_dead

@export var target: Node2D = null
@export var navigation_agent: NavigationAgent2D = null
			
func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("recalc_path")
	if collision_shape_2d != null:
		collision_shape_2d.set_deferred("disabled", false)

func _die():
	is_dead = true
	
func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
	
func spray_shadow_oil():
	if Globals.shadow_oil_manager != null:
		var random_placement = _random_inside_unit_circle() * 32
		Globals.shadow_oil_manager.add_shadow_oil(global_position + random_placement)
	
func receive_damage_with_knockback(amount: float, speed_vector: Vector2):
	animation_tree.is_hurt = true
	_knockback_velocity = speed_vector.normalized() * 10
	receive_damage(amount)
	_die()

func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	if animation_tree.is_dead:
		if collision_shape_2d != null:
			collision_shape_2d.set_deferred("disabled", true)
		velocity = Vector2.ZERO
	elif animation_tree.is_hurt:
		velocity = _knockback_velocity
	else:
		var axis = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = axis * _calculated_speed.value
		animation_tree["parameters/walk_speed/walk/blend_position"] = axis
	
	move_and_slide()

func recalc_path():
	if target:
		navigation_agent.target_position = target.position


func _on_recalculate_timer_timeout() -> void:
	recalc_path()
	recalculate_timer.wait_time = Globals.rng.randf_range(0.1, 0.2)
