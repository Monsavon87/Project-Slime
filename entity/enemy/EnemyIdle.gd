extends State

class_name EnemyIdleState

@export var move_component: MoveComponent
@export var min_duration: float = 1.0
@export var max_duration: float = 5.0

# Variables membres
var duration : float



# Called when the node enters the scene tree for the first time.
func enter():
	print("i wait")
	# set movement to zero
	move_component.velocity = Vector2.ZERO
	# Générer une durée aléatoire pour le mouvement
	duration = randf_range(min_duration, max_duration)
	await get_tree().create_timer(duration)
	Transitioned.emit(self, "Wander")
	print("i waited")
	
	
