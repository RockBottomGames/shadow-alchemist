extends Resource
class_name CharacterResource

var _min: CalculatedValue = CalculatedValue.new(0.0, 2)
var _max: CalculatedValue = CalculatedValue.new(0.0, 2)
var _current: PrecisionValue = PrecisionValue.new(0.0, 2)
var _regen: PrecisionValue = PrecisionValue.new(0.0, 2)
var _percentage_precision: int = 0
var _end_on_depleted: bool = true

func _init(
	max: float = 0.0,
	regen: float = 0.0,
	current: float = -1.0,
	end_on_depleted: bool = true,
	value_precision: int = 0,
	percentage_precision: int = 0,
	min: float = 0.0,
):
	_min = CalculatedValue.new(min, value_precision)
	_max = CalculatedValue.new(max, value_precision)
	_current = PrecisionValue.new(current if current != -1 else max, value_precision)
	_regen = PrecisionValue.new(regen, value_precision)
	_percentage_precision = percentage_precision
	_end_on_depleted = end_on_depleted

var is_depleted: bool:
	get:
		return _current.value <= _min.value

var percentage: PrecisionValue:
	get:
		return PrecisionValue.new((_current.value / _max.value) * 100.0, _percentage_precision)

func _to_string() -> String:
	return _current.to_string() + "/" + _max.to_string()

func process(delta):
	if (_end_on_depleted and is_depleted) or _regen.value == 0:
		return
	update_by(delta * _regen.value)

func increase_by(amount: float):
	if amount <= 0.0:
		return
	_current.value += amount

func decrease_by(amount: float):
	if amount <= 0.0:
		return
	_current.value -= amount

func update_by(amount: float):
	if amount > 0.0:
		increase_by(amount)
	elif amount < 0.0:
		decrease_by(amount)
