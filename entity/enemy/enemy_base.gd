extends CharacterBody2D

@export var speed = 50
@export var nav_agent: NavigationAgent2D
@export var target_distance = 30
@export var aggro_distance = 10
@export var deaggro_distance = 50
@export var navReg = NavigationRegion2D

var target = null
var target_node = null
var home_pos = Vector2.ZERO
var aggro_shape = CircleShape2D.new()
var deaggro_shape = CircleShape2D.new()
var map
var path = []

@onready var aggro_collision_shape_2d: CollisionShape2D = $Aggro/AggroRange/AggroCollisionShape2D
@onready var de_aggro_collision_shape_2d: CollisionShape2D = $Aggro/DeAggroRange/DeAggroCollisionShape2D



func _ready() -> void:
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 10 
	nav_agent.target_desired_distance = target_distance
		
	aggro_shape.radius = aggro_distance
	aggro_collision_shape_2d.set_shape(aggro_shape)
	deaggro_shape.radius = deaggro_distance
	de_aggro_collision_shape_2d.set_shape(deaggro_shape)
	
	call_deferred("setup_navserver")
	
func _physics_process(delta: float) -> void:
	#if nav_agent.is_navigation_finished():
		#return
	##var axis = to_local(nav_agent.get_next_path_position()).normalized()
	##var axis = nav_agent.get_next_path_position() - global_position
	#var current_pos = global_position
	#var next_path_pos = nav_agent.get_next_path_position()
	#var axis = current_pos.direction_to(next_path_pos)
	#
	#velocity = axis * speed
	#
	#move_and_slide()
	pass
	
func _process(delta: float) -> void:
	var walk_distance = speed * delta
	move_along_path(walk_distance)

func move_along_path(distance):
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			self.position = last_point.lerp(path[0], distance / distance_between_points)
			return
		
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	self.position = last_point
	set_process(false)

func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos
		
func setup_navserver ():
	#create a new navigation map
	map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map, true)
	
	#create a new navigation region and add it to the map
	var region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region, Transform2D())
	NavigationServer2D.region_set_map(region, map)
	NavigationServer2D.map_set_cell_size(map, 1)
	#set navigation mesh for the region
	var navigation_poly = NavigationMesh.new()
	navigation_poly = navReg.navigation_polygon
	NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)

func _update_navigation_path(start_position, end_position):
	path = NavigationServer2D.map_get_path(map, start_position, end_position, true)
	path.remove_at(0)
	set_process(true)
	
func _on_nav_update_timer_timeout() -> void:
	#recalc_path()
	if target:
		target_node = target.global_position
		_update_navigation_path(self.position, target_node)
	else:
		_update_navigation_path(self.position, home_pos)

func _on_aggro_range_area_entered(area: Area2D) -> void:
	#target_node = area.owner.global_position
	target = area.owner
	print("player detected")
	

func _on_de_aggro_range_area_exited(area: Area2D) -> void:
	if area.owner == target:
		#target_node = null
		target = null
		
		print("player lost")
