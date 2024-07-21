extends CharacterBody2D

const _PRECISION: int = 2

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

func _ready():
	_calculated_speed = CalculatedValue.new(speed, _PRECISION)
	
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = input_direction * _calculated_speed.value

func _physics_process(delta):
	get_input()
	move_and_slide()
