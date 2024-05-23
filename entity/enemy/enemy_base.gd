extends CharacterBody2D

@export var speed = 50
@export var nav_agent: NavigationAgent2D
@export var target_distance = 30
@export var move_component: MoveComponent
@export var aggro_distance = 10
@export var deaggro_distance = 50

var target_node = null
var home_pos = Vector2.ZERO
var aggro_shape = CircleShape2D.new()
var deaggro_shape = CircleShape2D.new()


@onready var aggro_collision_shape_2d: CollisionShape2D = $Aggro/AggroRange/AggroCollisionShape2D
@onready var de_aggro_collision_shape_2d: CollisionShape2D = $Aggro/DeAggroRange/DeAggroCollisionShape2D



func _ready() -> void:
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4 
	nav_agent.target_desired_distance = target_distance
		
	aggro_shape.radius = aggro_distance
	aggro_collision_shape_2d.set_shape(aggro_shape)
	deaggro_shape.radius = deaggro_distance
	de_aggro_collision_shape_2d.set_shape(deaggro_shape)
	
	
func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	
	move_and_slide()
	
func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos
		

		


func _on_nav_update_timer_timeout() -> void:
	recalc_path()


func _on_aggro_range_area_entered(area: Area2D) -> void:
	target_node = area.owner


func _on_de_aggro_range_area_exited(area: Area2D) -> void:
	if area.owner == target_node:
		target_node = null
