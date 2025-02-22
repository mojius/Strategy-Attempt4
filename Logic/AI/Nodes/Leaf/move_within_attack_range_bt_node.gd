class_name MoveWithinAttackRangeBTNode
extends BTNode

func run() -> bool:

    var tm: TileManager = blackboard["TileManager"]
    var move_cells: Array = blackboard["MoveCells"]
    var unit: Unit = blackboard["Unit"]
    var target: Unit = blackboard["Target"]

    var unit_pos := tm.local_to_map(unit.position)
    var target_pos := tm.local_to_map(target.position)

    var path: Array = tm.astar(unit_pos, move_cells, target_pos)
    
    for cell in path:
        if tm.heuristic(cell, target_pos) < unit.stats.attack_range:
            path.erase(cell)

    unit.set_path(path, tm)
    await unit.finished_walking

    return true
