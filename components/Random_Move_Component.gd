extends Node

# Composant de mouvement aléatoire
class_name RandomMoveComponent

# Propriétés exportées
@export var min_speed: float = 50.0
@export var max_speed: float = 100.0
@export var move_component: MoveComponent
#var speed = 100
# Variables membres


func _ready():
			# Démarrer la coroutine pour générer des mouvements aléatoires
	pass
	
func start_random_movement() ->void:
		# Générer une direction et une vitesse aléatoire
		var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		print(direction)
		var speed = randf_range(min_speed, max_speed)

		# Affecter la direction et la vitesse au composant de mouvement
		move_component.velocity = direction * speed
		print("i moved")
		

