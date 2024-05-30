extends CharacterBody2D
## Base agent script that is shared by all agents.

# Signal emitted when the agent dies
signal death



# Flag indicating if the agent is dead
var _is_dead: bool = false
# Flag indicating if the agent moved during the current frame
var _moved_this_frame: bool = false
# Flag indicating if the agent is currently attacking
var _is_attacking: bool = false
# used in dodge
var dodge_dir: Vector2
# Animation player node for playing animations
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Health component for managing agent's health
@onready var health: Health = $Health
# Root node of the agent
@onready var root: Node2D = $Root
# Collision shape of the agent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Animation tree for controlling animations
@onready var animation_tree: AnimationTree = $AnimationTree as AnimationTree
# Animation state within the animation tree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var melee_weapon: Node2D = $MeleeWeapon

# Called when the node is ready
func _ready() -> void:
	# Connect the 'damaged' signal to the '_damaged' method
	health.damaged.connect(_damaged)
	
	# Connect the 'death' signal to the 'die' method
	health.death.connect(die)
	melee_weapon.visible = false
# Process physics logic
func _physics_process(_delta: float) -> void:
	# Call the post-physics process method deferred
	_post_physics_process.call_deferred()

# Post-physics processing logic
func _post_physics_process() -> void:
	# If currently attacking, return early
	if _is_attacking:
		return
	
	# If the agent didn't move during this frame, gradually reduce velocity to zero
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
		animation_state.travel("Idle")
	
	# Reset the flag indicating if the agent moved during this frame
	_moved_this_frame = false

# Move the agent with the specified velocity
func move(p_velocity: Vector2) -> void:
	# If currently attacking, return early
	if _is_attacking:
		return
	
	# If the velocity is non-zero, update the direction and move the agent
	if p_velocity != Vector2.ZERO:
		dodge_dir = p_velocity
		velocity = lerp(velocity, p_velocity, 0.2)
		animation_tree.set("parameters/Walk/Walk/blend_position", p_velocity)
		animation_tree.set("parameters/Idle/Idle/blend_position", p_velocity)
		animation_state.travel("Walk")    
		move_and_slide()
		_moved_this_frame = true

# Start the attack animation
func attacking():
	_is_attacking = true
	melee_weapon.visible = true
# Stop the attack animation
func stop_attacking():
	_is_attacking = false
	melee_weapon.visible = false
# Check if the specified position is within the arena and not inside an obstacle
func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 1 # Obstacle layer has value 1
	var collision := space_state.intersect_point(params)
	return collision.is_empty()

# Method called when the agent is damaged
func _damaged(_amount: float, knockback: Vector2) -> void:
	# Apply knockback to the agent
	apply_knockback(knockback)
	
	# Play the hurt animation
	#animation_player.play(&"hurt")
	
	# Disable other components during the hurt animation
	var btplayer := get_node_or_null(^"BTPlayer") as BTPlayer
	if btplayer:
		btplayer.set_active(false)
	var hsm := get_node_or_null(^"LimboHSM")
	if hsm:
		hsm.set_active(false)
	
	# Wait for the hurt animation to finish
	#await animation_player.animation_finished
	
	# Restart components after the hurt animation finishes
	if btplayer and not _is_dead:
		btplayer.restart()
	if hsm and not _is_dead:
		hsm.set_active(true)

# Apply knockback to the agent for a specified number of frames
func apply_knockback(knockback: Vector2, frames: int = 10) -> void:
	if knockback.is_zero_approx():
		return
	for i in range(frames):
		move

func die() -> void:
	if _is_dead:
		return
	death.emit()
	_is_dead = true
	root.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play(&"death")
	collision_shape_2d.set_deferred(&"disabled", true)

	for child in get_children():
		if child is BTPlayer or child is LimboHSM:
			child.set_active(false)

	if get_tree():
		await get_tree().create_timer(5.0).timeout
		queue_free()


func get_health():
	print(player_data.health)
	#var health_node = $Health
	#var health = health_node.get_current()
	#return health
	
