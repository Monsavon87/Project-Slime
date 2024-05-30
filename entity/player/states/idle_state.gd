#*
#* idle_state.gd
#* =============================================================================
#* Copyright 2021-2024 Serhii Snitsaruk
#*
#* Use of this source code is governed by an MIT-style
#* license that can be found in the LICENSE file or at
#* https://opensource.org/licenses/MIT.
#* =============================================================================
#*
extends LimboState
## Idle state.





func _enter() -> void:
	#animation_player.play(idle_animation, 0.1)
	pass

func _update(_delta: float) -> void:
	var horizontal_move: float = Input.get_axis("ui_left","ui_right")
	var vertical_move: float = Input.get_axis("ui_up","ui_down")
	if horizontal_move != 0.0 or vertical_move != 0.0:
		get_root().dispatch(EVENT_FINISHED)
