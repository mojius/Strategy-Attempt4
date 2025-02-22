class_name UnitInAttackRangeBTNode
extends BTNode

func run() -> bool:
    var tm: TileManager = blackboard.get("TileManager")
    var unit: Unit = blackboard.get("Unit")

    var targets: Array = tm.get_attackable_targets(unit)

    if targets.size() > 0:
        blackboard["Target"] = targets[0]
        return true
    else: return false
