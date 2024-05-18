extends ParallaxBackground

@onready var space_layer: ParallaxLayer = %SpaceLayer
@onready var far_stars_layer: ParallaxLayer = %FarStarsLayer
@onready var close_stars_layer: ParallaxLayer = %CloseStarsLayer

func _process(delta: float) -> void:
	close_stars_layer.motion_offset.y += 20 * delta
	far_stars_layer.motion_offset.y += 5 * delta
	space_layer.motion_offset.y += 2 * delta
	
