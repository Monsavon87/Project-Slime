class_name MoveComponent
extends Node

@export var actor: Node2D
@export var velocity: Vector2

func _process(delta: float) -> void:
	actor.translate(velocity * delta)
	
#func _physics_process(delta: float) -> void:
	#actor.move_and_slide
	
