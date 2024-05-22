extends State
class_name EnemyChaseState


@export var move_speed := 40
@export var move_component = MoveComponent
@export var chase_range = 25
@export var stop_chase = 50
@export var my_self = CharacterBody2D
var player: CharacterBody2D
 
@onready var navigation_agent_2d: NavigationAgent2D = $"../../ChasingAI/NavigationAgent2D"

 
func _ready() -> void:
	set_physics_process(false)

func enter():
	print("chasing")
	set_physics_process(true)
	player = get_tree().get_first_node_in_group("Player")
	

	
	
#func Physics_Update(delta: float):

func _physics_process(delta: float) -> void:
	var distance = player.global_position - my_self.global_position
	var next_path_position := navigation_agent_2d.get_next_path_position()
	
	if distance.length() > chase_range:
		#move_component.velocity = direction.normalized() * move_speed
		move_component.velocity = next_path_position * move_speed
	else:
		move_component.velocity = Vector2()
		
	if distance.length() > stop_chase:
		Transitioned.emit(self, "Idle")
	
# func _physics_process(_delta: float) -> void:
	#if navigation_agent_2d.is_navigation_finished():
	#	return
		
	
		
	
	# move_and_slide()
	
func makepath() -> void:
	
	navigation_agent_2d.target_position = player.global_position
	


func _on_timer_timeout() -> void:
	makepath()

func exit():
	print("stop chasing")
	set_physics_process(false)
