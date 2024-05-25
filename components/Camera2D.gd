extends Camera2D

@export var ground: TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mapRect = ground.get_used_rect()
	var tileSize = ground.cell_quadrant_size
	var worlSizeInPixels = mapRect.size * tileSize
	limit_right = worlSizeInPixels.x
	limit_bottom = worlSizeInPixels.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
