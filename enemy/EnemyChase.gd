extends State
class_name EnemyChase

@export var enemy: Node2D
@export var move_speed := 40
@export var move_component = MoveComponent
@export var chase_range = 25
@export var stop_chase = 50

var player: CharacterBody2D

func enter():
	print("chasing")
	player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > chase_range:
		move_component.velocity = direction.normalized() * move_speed
		
	else:
		move_component.velocity = Vector2()
		
	if direction.length() > stop_chase:
		Transitioned.emit(self, "wander")
	

