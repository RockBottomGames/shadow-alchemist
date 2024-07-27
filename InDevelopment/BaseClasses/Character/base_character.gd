extends CharacterBody2D
class_name BaseCharacter

var _health_resource: CharacterResource = CharacterResource.new()

var _base_max_health: float = 100.0
@export var base_max_health: float = 100.0:
	# Update speed and reset the rotation.
	set(new_base_max_health):
		if new_base_max_health == base_max_health:
			return
		base_max_health = new_base_max_health
		_health_resource = CharacterResource.new(base_max_health, base_health_regen)

var _base_health_regen: float = 1.0
@export var base_health_regen: float = 1.0:
	# Update speed and reset the rotation.
	set(new_base_health_regen):
		if new_base_health_regen == base_health_regen:
			return
		base_health_regen = new_base_health_regen
		_health_resource = CharacterResource.new(base_max_health, base_health_regen)

var health_resource: CharacterResource:
	get:
		return _health_resource

var _calculated_attack_damage = CalculatedValue.new(50.0)
@export var base_attack_damage: float = 50.0:
	# Update speed and reset the rotation.
	set(new_base_attack_damage):
		if new_base_attack_damage == base_attack_damage:
			return
		base_attack_damage = new_base_attack_damage
		_calculated_attack_damage = CalculatedValue.new(base_attack_damage)

var attack_damage: float:
	get:
		return _calculated_attack_damage.value

var _calculated_speed = CalculatedValue.new(400.0)
@export var base_speed: float = 400.0:
	# Update speed and reset the rotation.
	set(new_base_speed):
		if new_base_speed == base_speed:
			return
		base_speed = new_base_speed
		_calculated_speed = CalculatedValue.new(base_speed)

var speed: float:
	get:
		return _calculated_speed.value

func attack(other: BaseCharacter) -> void:
	other.health_resource.decrease_by(other.attack_damage)

func receive_damage(damage: float) -> void:
	health_resource.decrease_by(damage)

func _process(delta: float) -> void:
	health_resource.process(delta)

func _ready() -> void:
	_health_resource = CharacterResource.new(base_max_health, base_health_regen)
	_calculated_attack_damage = CalculatedValue.new(base_attack_damage)
	_calculated_speed = CalculatedValue.new(base_speed)
