class_name AttackUnitBTNode
extends BTNode

@onready var menu_scene: PackedScene = preload("res://2D/Font & Menu/UnitsAttackingSupportingMenu.tscn")
@onready var combat_panel: PackedScene = preload("res://2D/Font & Menu/CombatPanel.tscn")

func run() -> bool:

    var menu = menu_scene.instantiate()
    add_child(menu)

    var c1: CombatPanel = combat_panel.instantiate()
    var c2: CombatPanel = combat_panel.instantiate()

    c1.unit = blackboard.get("Unit")
    c2.unit = blackboard.get("Target")

    menu.add_child(c1)
    menu.add_child(c2)
    await interact(c1, c2)

    menu.queue_free()

    return true

func interact(aggressor: CombatPanel, target: CombatPanel):

    await aggressor.volley(target)
    if target.unit.stats.hp > 0: 
        await target.volley(aggressor)
    if not (aggressor.unit.is_queued_for_deletion() or target.unit.is_queued_for_deletion()):
        await get_tree().create_timer(0.3).timeout
