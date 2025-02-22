class_name Cursor
extends AnimatedSprite2D

var tile_manager: TileManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = tile_manager.map_to_local(tile_manager.local_to_map(get_viewport().get_mouse_position()))
