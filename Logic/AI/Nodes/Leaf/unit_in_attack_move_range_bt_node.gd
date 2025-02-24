class_name UnitInAttackMoveRangeBTNode
extends BTNode


func run() -> bool:
    var tm: TileManager = blackboard.get("TileManager")
    var unit: Unit = blackboard.get("Unit")
    var target: Unit = blackboard.get("Target")

    var move_cells = tm.get_traversable(tm.local_to_map(unit.position), false, unit.stats.move_range, 1)
    var attack_cells = tm.get_all_attack_range(move_cells, unit.stats.attack_range, unit.faction)

    if tm.local_to_map(target.position) in attack_cells: 
        blackboard["AttackCells"] = attack_cells
        blackboard["MoveCells"] = move_cells        
        return true
    else: return false
