@tool
extends Resource
class_name PrecisionValue

@export var value: float = 0.0:
	get:
		return value
	set(new_value):
		if new_value == value:
			return
		value = new_value
		_formatted_value = ""

@export var precision: int = 0:
	# Update speed and reset the rotation.
	set(new_precision):
		if new_precision == precision:
			return
		precision = new_precision
		_formatted_value = ""

var _formatted_value : String = ""
var formatted_value : String:
	get:
		if _formatted_value.is_empty():
			_formatted_value = "%.*f" % [precision, value]
		return _formatted_value

func _init(
	_value: float = 0.0,
	_precision: int = 0
):
	self.value = _value
	self.precision = _precision

func _to_string() -> String:
	return formatted_value
