extends CharacterBody2D


@export var target: Node2D = null

var speed = 300
var acceleration = 7

@onready var navigation_agent_2d: NavigationAgent2D = $Node2D/NavigationAgent2D



func _physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var current_agent_position = global_position
	var next_path_position := navigation_agent_2d.get_next_path_position()
	#var dir := global_position.direction_to(next_path_position)
	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()
	
func makepath() -> void:
	navigation_agent_2d.target_position = target.global_position
	


func _on_timer_timeout() -> void:
	makepath()
