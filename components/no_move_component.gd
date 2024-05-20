class_name NoMoveComponent


extends Node

@export var move_component: MoveComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_component.velocity.x = 0
	move_component.velocity.y = 0
		 


