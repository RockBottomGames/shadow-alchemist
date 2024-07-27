@tool
extends Resource
class_name CalculatedValue

var _initial_value: PrecisionValue = PrecisionValue.new()
var _calculated_value: PrecisionValue = PrecisionValue.new()
var value : float:
	get:
		return _calculated_value.value
var formatted_value : String:
	get:
		return _calculated_value.formatted_value

func _to_string() -> String:
	return formatted_value

#@export var precision: int = 0:
	## Update speed and reset the rotation.
	#set(new_precision):
		#if new_precision == precision:
			#return
		#precision = new_precision
		#if Engine.is_editor_hint():
			#pass

func _init(
	initial_value: float = 0.0,
	precision: int = 0
):
	_initial_value = PrecisionValue.new(initial_value, precision)
	_calculated_value = PrecisionValue.new(initial_value, precision)
	
