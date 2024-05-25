class_name Level extends Node2D

## This class is not part of [class SceneManager], it's just here to make the sample
## project do something. All levels (i.e. the game content) extend from this class. 
## You will note that because Levels "want" to pass data between them, they implement
## the optional methods [method get_data] and [method receive_data]

@export var player = CharacterBody2D
@export var doors:Array[Door]
@export var ground_layer = TileMap 



var data:LevelDataHandoff
# Utilisation de la fonction pour obtenir les dimensions utilisées de la tilemap

@onready var navigation: NavigationRegion2D = $Navigation

func _ready() -> void:
	player.disable()
	player.visible = false
	# This block is here to allow us to test current scene without needing the SceneManager to call these :) 
	if data == null: 
		init_scene()
		start_scene()
	
	var used_rect = get_tilemap_used_rect(ground_layer)
	# Dessiner la région à l'intérieur de la NavigationRegion2D
	draw_navigation_region(used_rect)
	# "Bake" la NavigationRegion2D
	#bake_navigation_region()
	
	
## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to receive this data and pass it to the next scene
func get_data():
	return data
	
## 1) emitted at the beginning of SceneManager.on_content_finished_loading
## When a class implements this, SceneManager.on_content_finished_loading will invoke it
## to insert data received from the previous scene into this one	
func receive_data(_data):
	# implementing class should do some basic checks to make sure it only acts on data it's prepared to accept
	# if previous scene sends data this scene doesn't need, simple logic as follows ensures no crash occurs
	# act only on the data you want to receive and process :) 
	if _data is LevelDataHandoff:
		data = _data
		# process data here if need be, for this we just need to receive it but only if it's of the correct data type
	else:
		# SceneManager is designed to allow data mismatches like this occur, because you wno't always know
		# which scene precedes or follows another. For example, this sample project passes data between
		# levels but not between a level and the start screen, or vice versa. But it's possible Start screen might
		# look for data from a different scene. So both incoming and outgoing scenes might implement get/receive_data
		# but you may not always want to process that data. This is way more explanation than you need for something
		# that's pretty much designed to work this way and fail silently when not in use :D
		push_warning("Level %s is receiving data it cannot process" % name)

## emitted in the middle of SceneManager.on_content_finished_loading, after this scene is added to the tree
## 2) I use this to initialize stuff (like player start location) before user regains control
func init_scene() -> void:
	init_player_location()

## emitted at the very end of SceneManager.on_content_finished_loading, after the transition has completed
## 3) Here I'm using it to return control to the user because everything is ready to go
func start_scene() -> void:
	player.enable()
	_connect_to_doors()

## put player in front of the correct door, facing the correct direction
func init_player_location() -> void:
	player.visible = true
	#var doors = find_children("*","Door")
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				player.position = door.get_player_entry_vector()
		player.orient(data.move_dir)

## signal emitted by Door, # disables doors and players, create handoff data to pass to the new scene (if new scene is a Level)
func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.disable()
	# player.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()
	set_process(false)
		

## connects to all door signals in level
func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

## disconnect from all door signals in level			
func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
			



# Fonction pour obtenir les dimensions utilisées de la tilemap
func get_tilemap_used_rect(tilemap: TileMap) -> Rect2:
	var used_cells = tilemap.get_used_cells(0) # Utilisation de la couche 0
	#if used_cells.empty():
		#return Rect2(0, 0, 0, 0)
		   
	var min_x = used_cells[0].x
	var max_x = min_x
	var min_y = used_cells[0].y
	var max_y = min_y

	for cell in used_cells:
		if cell.x < min_x:
			min_x = cell.x
		elif cell.x > max_x:
			max_x = cell.x
		if cell.y < min_y:
			min_y = cell.y
		elif cell.y > max_y:
			max_y = cell.y

	var tile_size = tilemap.tile_set.tile_size
	var used_rect = Rect2(
		min_x * tile_size.x,
		min_y * tile_size.y,
		(max_x - min_x + 1) * tile_size.x,
		(max_y - min_y + 1) * tile_size.y
	)
	
	return used_rect

# Dessiner la région à l'intérieur de la NavigationRegion2D
func draw_navigation_region(used_rect: Rect2):
	#var nav_region = $NavigationRegion2D  # Assure-toi de remplacer "NavigationRegion2D" par le chemin correct vers ta NavigationRegion2D

	# Créer un nouveau polygone de navigation
	var new_navigation_mesh = NavigationPolygon.new()
	var bounding_outline = PackedVector2Array([
		Vector2(used_rect.position.x, used_rect.position.y),
		Vector2(used_rect.position.x, used_rect.position.y + used_rect.size.y),
		Vector2(used_rect.position.x + used_rect.size.x, used_rect.position.y + used_rect.size.y),
		Vector2(used_rect.position.x + used_rect.size.x, used_rect.position.y)
	])
	new_navigation_mesh.add_outline(bounding_outline)
	# Définir le polygone de navigation pour la NavigationRegion2D
	navigation.navigation_polygon = new_navigation_mesh
	
	# "Baker" le polygone de navigation
	navigation.bake_navigation_polygon()
	
	
	# Définir le polygone de navigation pour la NavigationRegion2D
	#navigation.navigation_polygon = new_navigation_mesh
	
# "Bake" la NavigationRegion2D
func bake_navigation_region():
	navigation.bake()
	
	

