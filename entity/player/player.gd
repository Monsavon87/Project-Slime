
class_name Player
extends "res://entity/scripts/agent_base.gd"

## Player.
@export var input_enabled:bool = true
@export var dodge_cooldown: float = 0.4
@export var sprite = Sprite2D

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState
@onready var attack_state: LimboState = $LimboHSM/AttackState
@onready var dodge_state: LimboState = $LimboHSM/DodgeState


var can_dodge: bool = true
var attack_pressed: bool = false
var mouse_vector: Vector2

func _ready() -> void:
	super._ready()
	can_dodge = true
	_init_state_machine()
	death.connect(func(): remove_from_group(&"player"))
	var health_node = $Health
	var health = health_node.get_max()
	player_data.health = health

func _process(_delta: float) -> void:
	# Obtenir la position actuelle de la souris dans le monde
	var mouse_position = get_global_mouse_position()

	# Calculer le vecteur entre le personnage et la souris
	var direction_to_mouse = (mouse_position - global_position)

	# Normaliser le vecteur
	mouse_vector = direction_to_mouse.normalized()
	
	var health_node = $Health
	var health = health_node.get_current()
	player_data.health = health
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event.is_action_pressed("attack"):
		attack_pressed = true
		_process_attack_input()
	if event.is_action_pressed("dodge"):
		hsm.dispatch("dodge!")
	if event.is_action_pressed("health"):
		get_health()

func _process_attack_input() -> void:
	if not attack_pressed or hsm.get_active_state() == attack_state:
		return
	hsm.dispatch("attack!")
	attack_pressed = false


func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	hsm.add_transition(idle_state, attack_state, "attack!")
	hsm.add_transition(move_state, attack_state, "attack!")
	hsm.add_transition(attack_state, move_state, attack_state.EVENT_FINISHED)
	hsm.add_transition(attack_state, idle_state, attack_state.EVENT_FINISHED)
	hsm.add_transition(hsm.ANYSTATE, dodge_state, "dodge!")
	hsm.add_transition(dodge_state, move_state, dodge_state.EVENT_FINISHED)

	dodge_state.set_guard(_can_dodge)
	attack_state.set_guard(attack_state.can_enter)

	# Process attack input buffer when move_state is entered.
	# This way we can buffer the attack button presses and chain the attacks.
	move_state.call_on_enter(_process_attack_input)

	hsm.initialize(self)
	hsm.set_active(true)
	hsm.set_guard(_can_dodge)


#func _add_action(p_action: StringName, p_key: Key, p_alt: Key = KEY_NONE) -> void:
	#if not InputMap.has_action(p_action):
		#InputMap.add_action(p_action)
		#var event := InputEventKey.new()
		#event.keycode = p_key
		#InputMap.action_add_event(p_action, event)
		#if p_alt != KEY_NONE:
			#var alt := InputEventKey.new()
			#alt.keycode = p_alt
			#InputMap.action_add_event(p_action, alt)


#func set_victorious() -> void:
	#idle_state.idle_animation = &"dance"


func _can_dodge() -> bool:
	if can_dodge:
		can_dodge = false
		get_tree().create_timer(dodge_cooldown).timeout.connect(func(): can_dodge = true)
		return true
	return false

func orient(dir:Vector2) -> void:
	if dir.x:
		sprite.flip_h = dir.x < 0

func disable():
	input_enabled = false
	animation_state.travel("Idle")

func enable():
	input_enabled = true
	visible = true
