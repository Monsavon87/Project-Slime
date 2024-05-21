# Virtual base class for all states.
class_name State
extends Node

signal Transitioned



# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float):
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float):
	pass



func enter():
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit():
	pass
