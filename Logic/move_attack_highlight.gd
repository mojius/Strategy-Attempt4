class_name MoveAttackHighlight
extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func show_range(unit: Unit, tm: TileManager) -> Array:
	var src_tile : Vector2i = local_to_map(unit.position) 
	var move_cells = tm.get_traversable(src_tile, false, unit.stats.move_range)
	var attack_cells = tm.get_all_attack_range(move_cells, unit.stats.min_atk_range, unit.stats.max_atk_range, unit.faction)

	for cell in attack_cells:
		set_cell(cell, 12, Vector2i(0,0))

	for cell in move_cells:
		set_cell(cell, 6, Vector2i(0,0))
	
	return move_cells

func reset() -> void:
	global_position = Vector2(0,0)
	clear()
