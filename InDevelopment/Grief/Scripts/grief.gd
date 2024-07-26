extends CharacterBody2D
class_name Grief

@onready var LINE_BULLET = preload("res://InDevelopment/Bottle/Line/line_bullet.tscn")
@onready var collection_area: ShadowCollectionArea = $CollectionArea

const _PRECISION: int = 2
const _FIRE_COOLDOWN: float = 0.5

var _line_bullets_pool: Array[LineBullet] = []

var _look_position: Vector2 = Vector2.ZERO

var _is_line_bullet_firing: bool = false
var _line_bullet_cooldown: float = 0

var _calculated_speed = CalculatedValue.new(400, _PRECISION)
@export var speed: float = 400.0:
	# Update speed and reset the rotation.
	set(new_speed):
		if new_speed == speed:
			return
		speed = new_speed
		_calculated_speed = CalculatedValue.new(speed, _PRECISION)
		if Engine.is_editor_hint():
			pass

var _calculated_line_bullet_speed = CalculatedValue.new(1000, _PRECISION)
@export var line_bullet_speed: float = 1000.0:
	# Update speed and reset the rotation.
	set(new_line_bullet_speed):
		if new_line_bullet_speed == line_bullet_speed:
			return
		line_bullet_speed = new_line_bullet_speed
		_calculated_line_bullet_speed = CalculatedValue.new(line_bullet_speed, _PRECISION)
		if Engine.is_editor_hint():
			pass

func _ready():
	_calculated_speed = CalculatedValue.new(speed, _PRECISION)
	_calculated_line_bullet_speed = CalculatedValue.new(line_bullet_speed, _PRECISION)
	for index in 100:
		_line_bullets_pool.append(LINE_BULLET.instantiate())

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		_look_position = get_parent().get_local_mouse_position()
		collection_area.point_to_global_position(get_global_mouse_position())
	if Input.is_action_just_pressed("secondary_fire"):
		collection_area.is_collecting = true
	if Input.is_action_just_released("secondary_fire"):
		collection_area.is_collecting = false
	
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = input_direction * _calculated_speed.value
	_is_line_bullet_firing = Input.is_action_pressed("direct_fire")

func line_bullet_hit(line_bullet: LineBullet):
	_line_bullets_pool.append(line_bullet)

func _physics_process(delta):
	get_input()
	if _line_bullet_cooldown > 0:
		_line_bullet_cooldown = _line_bullet_cooldown - delta
		
	move_and_slide()
	
	if _line_bullet_cooldown <= 0 and _is_line_bullet_firing:
		_line_bullet_cooldown = _FIRE_COOLDOWN
		var parent = self.get_parent()
		var line_bullet: LineBullet = _line_bullets_pool.pop_front()
		line_bullet.shoot(_calculated_line_bullet_speed.value, position, _look_position, velocity, parent, self)


#
#func _on_collection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#Globals.shadow_oil_manager.remove_shadow_oil(body_rid)
#
#
#func _on_suction_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	##PhysicsServer2D.body_apply_central_force()
	#pass
