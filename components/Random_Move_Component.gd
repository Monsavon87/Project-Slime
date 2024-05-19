extends Node

# Composant de mouvement aléatoire
class_name RandomMoveComponent

# Propriétés exportées
@export var min_speed: float = 50.0
@export var max_speed: float = 100.0
@export var move_component: MoveComponent

# Variables membres


func _ready():
		# Démarrer la coroutine pour générer des mouvements aléatoires
	start_random_movement()

func start_random_movement() ->void:
	while true:
		# Générer une direction et une vitesse aléatoire
		var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var speed = randf_range(min_speed, max_speed)

		# Affecter la direction et la vitesse au composant de mouvement
		move_component.velocity = direction * speed

		# Attendre un certain délai avant de générer un nouveau mouvement aléatoire
		#await get_tree().create_timer(randf_range(1.0, 3.0))

