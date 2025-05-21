class_name AttackGoal
extends GoalResource

var unit: Unit
var target: Unit
var tile_manager: TileManager
var path: Array

func query() -> bool:

    var unit_tile_pos = tile_manager.local_to_map(unit.position)
    var target_tile_pos = tile_manager.local_to_map(target.position)

    path = tile_manager.get_path_towards_destination(unit_tile_pos, unit.stats.move_range, target_tile_pos)
    print("Path is:")
    print(path)

    print("Target position is:")
    print(target_tile_pos)

    if target_tile_pos in path:
        return true

    return false
    



func commit():
    pass