class_name Ninja

extends Enemy

@onready var wander_state: TimedStateComponent = %WanderState

@onready var states: Node = %states
@onready var idle_state: TimedStateComponent = %IdleState


func _ready() -> void:
	super()
	
	for state in states.get_children():
		state = state as StateComponent
		state.disable()
	
	print("1")
	idle_state.state_finished.connect(wander_state.enable)
	print("2")
	wander_state.state_finished.connect(idle_state.enable)
	print("3")
	idle_state.enable()
	print("4")
	
	
	
