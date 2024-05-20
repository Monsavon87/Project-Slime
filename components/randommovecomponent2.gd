extends Node

# Composant de mouvement aléatoire
class_name RandomMoveTimedComponent

# Propriétés exportées
@export var min_duration: float = 2.0
@export var max_duration: float = 5.0
@export var min_speed: float = 50.0
@export var max_speed: float = 100.0

@export var move_component: MoveComponent


# Variables membres
var moving: bool = false

func _ready():
	# Récupérer le composant de mouvement attaché à cette entité
	start_random_movement()

func start_random_movement():
	# Vérifier si le mouvement aléatoire est déjà en cours
	if moving:
		return

	# Activer le mouvement aléatoire
	moving = true

	# Générer une durée aléatoire pour le mouvement
	var duration = randf_range(min_duration, max_duration)

	# Générer une direction et une vitesse aléatoires
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var speed = randf_range(min_speed, max_speed)

	# Affecter la direction et la vitesse au composant de mouvement
	move_component.velocity = direction * speed

	# Démarrer une temporisation pour désactiver le mouvement après la durée spécifiée
	await get_tree().create_timer(duration).timeout
	_on_Timer_timeout()

func _on_Timer_timeout():
	# Désactiver le mouvement aléatoire
	moving = false
	move_component.velocity = Vector2.ZERO
