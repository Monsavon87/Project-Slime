extends Enemy

@onready var random_move_timed_component: RandomMoveTimedComponent = $RandomMoveTimedComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_move_timed_component._ready()
	random_move_timed_component.moving


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
