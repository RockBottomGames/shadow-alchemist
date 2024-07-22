extends Area2D
class_name LineBullet

var _parented_by: Node = null
var _caller: Node = null
var _speed_vector: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2(1, 0)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

func shoot(speed: float, starting_point: Vector2, target_point: Vector2, shooter_velocity: Vector2, parented_by: Node, caller: Node):
	_direction = (target_point - starting_point).normalized()
	position = starting_point + (_direction * 50.0)
	if _parented_by != null:
		_parented_by.remove_child(self)
		pass
	parented_by.add_child(self)
	animated_sprite_2d.play()
	animated_sprite_2d_2.play()
	_parented_by = parented_by
	_caller = caller
	_speed_vector = (speed * _direction)

func hit():
	if _parented_by != null:
		animated_sprite_2d.pause()
		animated_sprite_2d_2.pause()
		_parented_by.remove_child(self)
		if _caller.has_method("line_bullet_hit"):
			_caller.line_bullet_hit(self)
		pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position + _speed_vector * delta
	


func _on_body_entered(body: Node2D) -> void:
	hit()


#func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#hit()
