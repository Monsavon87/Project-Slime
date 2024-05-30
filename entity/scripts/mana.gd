class_name Mana
extends Node
## Tracks health and emits signal when damaged or dead.

## Emitted when health is reduced to 0.
signal oom

## Emitted when health is damaged.
signal damaged(amount: float, knockback: Vector2)

## Initial health value.
@export var max_health: float = 10.0

var _current: float


func _ready() -> void:
	_current = max_health


func take_damage(amount: float, knockback: Vector2) -> void:
	if _current <= 0.0:
		return

	_current -= amount
	_current = max(_current, 0.0)

	if _current <= 0.0:
		oom.emit()
	else:
		damaged.emit(amount, knockback)


## Returns current health.
func get_current() -> float:
	return _current
