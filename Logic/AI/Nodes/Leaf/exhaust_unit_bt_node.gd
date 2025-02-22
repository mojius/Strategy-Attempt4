class_name ExhaustUnitBTNode
extends BTNode

func run() -> bool:
    var unit: Unit = blackboard["Unit"]
    if unit:
        unit.exhausted = true
        return true
    return false
