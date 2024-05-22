extends State

class_name EnemyIdleState

@export var move_component: MoveComponent
@export var min_duration: float = 1.0
@export var max_duration: float = 5.0

# Variables membres
var duration : float

func _ready() -> void:
	set_physics_process(false)

# Called when the node enters the scene tree for the first time.
func enter():
	print("i wait")
	set_physics_process(true)
	duration = randf_range(min_duration, max_duration)
	get_tree().create_timer(duration)
	await SceneTreeTimer
	Transitioned.emit(self, "Wander")
	print("i waited")
	
	
	
func physics_update(_delta: float):
	# set movement to zero
	move_component.velocity = Vector2.ZERO
	# Générer une durée aléatoire pour le mouvement
	
	
func exit():
	set_physics_process(false)
	
