class_name BehaviorTree
extends Node

var blackboard:= Dictionary()
var unit
var first_node: BTNode

func _ready() -> void:
    first_node = get_child(0)
    if not first_node: return

    for node: BTNode in find_children("*", "", true, false):
        node.blackboard = blackboard
    
    blackboard["Unit"] = get_parent()
    blackboard["TileManager"] = get_parent().get_node("%TileManager")
    blackboard["Units"] = get_parent().get_node("%Units")

func run() -> void:
    print("BT Started for ", get_parent().name, "!")
    await first_node.run()
    await get_tree().create_timer(0.3).timeout
