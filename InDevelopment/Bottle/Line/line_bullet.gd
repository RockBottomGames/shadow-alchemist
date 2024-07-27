extends Area2D
class_name LineBullet

var _decommissioned: bool = false
var _parented_by: Node = null
var _caller: Node = null
var _speed_vector: Vector2 = Vector2.ZERO
var _speed: float = 0.0
var _direction: Vector2 = Vector2(1, 0)
var _damage: float = 10.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func shoot(damage: float, speed: float, starting_point: Vector2, target_point: Vector2, _shooter_velocity: Vector2, parented_by: Node, caller: Node):
	_direction = (target_point - starting_point).normalized()
	position = starting_point + (_direction * 50.0)
	if _parented_by != null:
		_parented_by.remove_child(self)
		pass
	parented_by.add_child(self)
	animated_sprite_2d.play()
	_parented_by = parented_by
	_caller = caller
	_speed = speed
	_speed_vector = (_speed * _direction)
	_damage = damage
	if collision_shape_2d != null:
		collision_shape_2d.set_deferred("disabled", false)

func hit():
	if collision_shape_2d != null:
		collision_shape_2d.set_deferred("disabled", true)
	if _parented_by != null:
		animated_sprite_2d.pause()
		_decommissioned = true
		if _caller.has_method("line_bullet_hit"):
			_caller.line_bullet_hit(self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision_shape_2d != null:
		collision_shape_2d.set_deferred("disabled", false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position + _speed_vector * delta

func _process(_delta: float) -> void:
	if _decommissioned:
		_decommissioned = false
		_parented_by.remove_child(self)
		#_parented_by.call_deferred("remove_child", self)

func _on_body_entered(body: Node2D) -> void:
	hit()
	if body.has_method("receive_damage_with_knockback"):
		body.receive_damage_with_knockback(_damage, _speed_vector)


#func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#hit()
