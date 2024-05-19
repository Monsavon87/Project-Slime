class_name MoveInputComponent
extends Node

@export var move_component: MoveComponent
@export var move_stats: MoveStats

func _input(event: InputEvent) -> void:
	# Initialiser le vecteur de direction à (0, 0)
	var move_direction = Vector2.ZERO

	# Vérifier les touches appuyées
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_direction.y += 1

	# Normaliser le vecteur de direction pour éviter les déplacements diagonaux plus rapides
	move_direction = move_direction.normalized()

	# Affecter le vecteur de direction à la vélocité du composant de mouvement
	move_component.velocity = move_direction * move_stats.speed
