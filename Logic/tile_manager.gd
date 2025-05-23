class_name TileManager
extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_cell_tiles_data(coords: Vector2i) -> Array[TileData]:
	var array = []
	for t: TileMapLayer in get_children():
		array.add(t.get_cell_tile_data(coords))
	return array



func get_traversable(start: Vector2i, above_terrain: bool = false, max_range = 100, faction: int = 0, goal := Vector2i(-1,-1)) -> Array:
	var frontier := PriorityQueue.new()
	frontier.insert(start, 0)
	var came_from := Dictionary()
	var cost_so_far = Dictionary()
	came_from[start] = null
	cost_so_far[start] = 0

	while not frontier.is_empty():
		var current = frontier.extract()
		
		if current == goal:
			break
		
		for next in get_surrounding_cells(current):
			if next not in get_used_cells(): continue 
			if get_impassable(next, faction) and not above_terrain: continue

			var new_cost = cost_so_far.get(current, 0) + get_move_cost(next)
			if above_terrain: new_cost = cost_so_far.get(current,0) + 1

			if new_cost > max_range: continue

			if next not in cost_so_far or new_cost < cost_so_far.get(next, 0):
				cost_so_far[next] = new_cost
				var priority = new_cost + heuristic(goal, next)
				frontier.insert(next,priority)
				came_from[next] = current

	var array:= []
	for tile in came_from:
		array.append(tile)
	
	return array

func get_astar_path(start: Vector2i, area: Array, goal := Vector2i(-1,-1)):
	var frontier := PriorityQueue.new()
	frontier.insert(start, 0)
	var came_from := Dictionary()
	var cost_so_far = Dictionary()
	came_from[start] = null
	cost_so_far[start] = 0

	if goal not in area:
		var current_closest = Vector2i(9999,9999)
		for cell in area:
			if direct_distance(cell,goal) < direct_distance(current_closest,goal) and not get_impassable(cell, -1):
				current_closest = cell
		if current_closest != Vector2i(9999,9999):
			goal = current_closest

	var current: Vector2i
	while not frontier.is_empty():
		current = frontier.extract()
		
		if current == goal:
			break
		
		for next in get_surrounding_cells(current):
			if next not in area: continue

			# if get_impassable(next): continue

			# change this later
			var new_cost = cost_so_far.get(current, 0) + get_move_cost(next)
			

			if next not in cost_so_far or new_cost < cost_so_far.get(next, 0):
				cost_so_far[next] = new_cost
				var priority = new_cost + heuristic(goal, next)
				frontier.insert(next,priority)
				came_from[next] = current

	var path := []
	while (current != start):
		path.append(current)
		current = came_from[current]
	
	path.append(start)
	path.reverse()
	return path

func heuristic(a: Vector2i, b: Vector2i):
	# manhattan distance on a square grid
	return abs(a.x - b.x) + abs(a.y - b.y)

func direct_distance(a: Vector2i, b: Vector2i):
	# Direct distance
	return a.distance_to(b)

func get_move_cost(coords: Vector2i) -> int:

	var terrain_cost = get_cell_tile_data(coords).get_custom_data("Move Cost")
	var decor = $Decoration.get_cell_tile_data(coords)
	if decor == null: return terrain_cost

	if decor.get_custom_data("Bridge") == true: return 1

	var decor_cost = decor.get_custom_data("Move Cost")

	if terrain_cost >= decor_cost: return terrain_cost 
	else: return decor_cost
		
func get_impassable(coords: Vector2i, faction: int) -> bool:

	var target = get_unit_at_cell(coords)
	if target:
		if faction == -1:
			return true
		elif $Units.opposes_faction(faction, target.faction):
			return true

	var water = get_cell_tile_data(coords).get_custom_data("Water")
	if water and $Decoration.get_cell_tile_data(coords) == null: return true

	var terrain_pass = get_cell_tile_data(coords).get_custom_data("Impassable")
	var decor = $Decoration.get_cell_tile_data(coords)
	
	if decor == null: return terrain_pass
	var decor_pass = decor.get_custom_data("Impassable")

	return terrain_pass or decor_pass

# Returns the area in which you can attack, based on your move area and your max attack range.
func get_all_attack_range(area: Array, min_range: int, max_range: int) -> Array:
	var attack_area: Array = []
	for cell in area:
		attack_area += get_attackable_tiles(cell, min_range, max_range) 
		
	return attack_area

func get_attackable_tiles(start: Vector2i, min_range: int, max_range: int) -> Array:
	var frontier := []
	frontier.push_back(start)
	var visited := []
	var cost_so_far = Dictionary()
	cost_so_far[start] = 0

	while not frontier.is_empty():
		var current = frontier.pop_front()
		
		for next in get_surrounding_cells(current):
			if next not in get_used_cells(): continue 

			var new_cost = cost_so_far.get(current,0) + 1

			if new_cost > max_range: continue

			if next not in cost_so_far or new_cost < cost_so_far.get(next, 0):
				cost_so_far[next] = new_cost
				frontier.push_back(next)
				visited.push_back(next)

	var array:= []
	for tile in visited:
		if (cost_so_far[tile] >= min_range and cost_so_far[tile] <= max_range):
			array.append(tile)
	
	return array


# Returns the targets you can attack (from a standstill position.)
func get_attackable_targets(unit: Unit) -> Array:
	var attack_area = get_attackable_tiles(local_to_map(unit.position), unit.stats.min_atk_range, unit.stats.max_atk_range)
	var targets: Array = []
	for cell in attack_area:
		var target = get_unit_at_cell(cell)
		if target and not target == unit and $Units.opposes_faction(unit.faction, target.faction):
			targets.append(target)
	return targets

func get_unit_at_cell(pos: Vector2i) -> Unit:
	for unit in $Units.find_children("*", "", true, false):
		if unit and unit is Unit and local_to_map(unit.position) == pos:
			return unit
	return null

func get_closest_enemy(unit: Unit) -> Unit:
	var enemies: Array
	if unit.faction == 0 or unit.faction == 2:
		enemies = $Units.get_all_units_in_faction(1)
	elif unit.faction == 1:
		enemies = $Units.get_all_units_in_faction(2) + $Units.get_all_units_in_faction(0)
	var all_move_area: Array = get_traversable(local_to_map(unit.position), false, 100, unit.faction)
	
	enemies.sort_custom(func(a: Unit, b: Unit): 
		var a_coords = local_to_map(a.position)
		var b_coords = local_to_map(b.position)
		var unit_coords = local_to_map(unit.position)
		var first_test = get_astar_path(unit_coords, all_move_area, a_coords).size()
		var second_test = get_astar_path(unit_coords, all_move_area, b_coords).size()
		return first_test < second_test)

	if enemies.size() > 0:
		return enemies[0]
	
	print("get_closest_enemy: Could not find any enemy at all!")
	return null

func get_path_towards_destination(start: Vector2i, max_range: int, destination: Vector2i, faction: int = 0) -> Array:
	var all_move_area: Array = get_traversable(start, false, 100, faction)
	var path: Array = get_astar_path(start, all_move_area, destination)

	var total_cost = 0
	var adjusted_path: Array = []
	for cell in path:
		var move_cost = get_move_cost(cell)
		total_cost += move_cost
		if total_cost > max_range:
			break
		adjusted_path.append(cell)

	return adjusted_path
