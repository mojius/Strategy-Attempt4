class_name PathArrow
extends TileMapLayer
	
var tm : TileManager
var path: Array = []
var _area: Array

var _drawing: bool = false
var source: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

func _process(_delta: float) -> void:
	if _drawing: draw()
	else: clear()

func show_arrow(local_pos: Vector2, area: Array,  _tm : TileManager = null):
	source = local_pos

	_area = area
	
	if _tm:
		tm = _tm

	_drawing = true


func hide_arrow():
	_drawing = false


func draw() -> void:
	clear()

	path = tm.astar(local_to_map(source), _area, local_to_map(get_viewport().get_mouse_position()))
	
	#if path.size() >= _max_range + 1:
	#	path.resize(_max_range + 1)

	set_cells_terrain_connect(path, 0, 0)
	var stop_arrow := Vector2i(0,0)
	var arrow_coords: Vector2i = get_cell_atlas_coords(path[0])

	# Hee hee hee... Hardcoding arrow directions.
	if arrow_coords == Vector2i(0,2):
		stop_arrow = Vector2i(3,0)
	elif arrow_coords == Vector2i(1,2):
		stop_arrow = Vector2i(2,0)
	elif arrow_coords == Vector2i(0,3):
		stop_arrow = Vector2i(0,0)
	elif arrow_coords == Vector2i(1,3):
		stop_arrow = Vector2i(1,0)	

	set_cell(path[0], 0, stop_arrow)

	if path.size() == 1: 
		set_cell(path[0], 0, Vector2i(2,3))


func reset() -> void:
	global_position = Vector2(0,0)
	hide_arrow()
	
