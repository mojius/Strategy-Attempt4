class_name MoveTowardsUnitBTNode
extends BTNode

func run() -> bool:
    var tm: TileManager = blackboard["TileManager"]
    var unit: Unit = blackboard["Unit"]
    var target: Unit = blackboard["Target"]

    var path = tm.get_path_towards_destination(tm.local_to_map(unit.position), unit.stats.move_range, tm.local_to_map(target.position))

    unit.set_path(path, tm)
    await unit.finished_walking

    return true
