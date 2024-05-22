class_name ChasingAi

extends Node2D

@export var target: Node2D
@export var move_component: MoveComponent

var speed = 100
var acceleration = 7

@onready var navigation_agent_2d: NavigationAgent2D = $bip/ChasingAI/NavigationAgent2D


func _ready() -> void:
	await get_tree().fram

# func _physics_process(_delta: float) -> void:
	#if navigation_agent_2d.is_navigation_finished():
	#	return
		
	var next_path_position := navigation_agent_2d.get_next_path_position()
	move_component.velocity = global_position.direction_to(next_path_position) * speed
	
	# move_and_slide()
	
func makepath() -> void:
	
	navigation_agent_2d.target_position = target.global_position
	


func _on_timer_timeout() -> void:
	makepath()
