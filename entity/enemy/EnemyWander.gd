extends State

class_name EnemyWanderState



# Propriétés exportées
@export var min_duration: float = 2.0
@export var max_duration: float = 5.0
@export var min_speed: float = 50.0
@export var max_speed: float = 100.0
@export var move_component: MoveComponent
@export var my_self: CharacterBody2D
# Variables membres
var duration : float
var move_direction : Vector2
var speed : float
var player: CharacterBody2D

func _ready() -> void:
	set_physics_process(false)

# Called when the node enters the scene tree for the first time.
func enter():
	print("moving")
	set_physics_process(true)
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func exit():
	set_physics_process(false)

func update(_delta: float):
	print("waiting")
	if duration > 0:
		duration -= _delta
	else:
		randomize_wander()
		
func _physics_process(delta: float) -> void:
	# Affecter la direction et la vitesse au composant de mouvement
	move_component.velocity = move_direction * speed
	
	var distance = player.get_position_delta() - my_self.global_position
	
	if distance.length() < 30:
		Transitioned.emit(self, "Chase")
	
func randomize_wander():
	# Générer une durée aléatoire pour le mouvement
	duration = randf_range(min_duration, max_duration)

	# Générer une direction et une vitesse aléatoires
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	speed = randf_range(min_speed, max_speed)
	print("direction set", move_direction)	
