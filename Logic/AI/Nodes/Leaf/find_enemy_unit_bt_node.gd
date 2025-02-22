class_name FindEnemyUnitBTNode
extends BTNode

func run() -> bool:
    var tm: TileManager = blackboard.get("TileManager")
    var unit: Unit = blackboard.get("Unit")
    
    var target = tm.get_closest_enemy(unit)

    if target: 
        blackboard["Target"] = target
        return true

    
    return false