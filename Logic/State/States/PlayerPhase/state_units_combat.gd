# Units interacting. Currently this means attacking each other or healing each other.
class_name StateUnitsAttackingSupporting
extends State

@onready var menu: HBoxContainer = $UnitsCombatMenu
@onready var combat_panel: PackedScene = preload("res://2D/Menu/CombatPanel.tscn")

func state_enter():
	menu.show()
	var c1: CombatPanel = combat_panel.instantiate()
	var c2: CombatPanel = combat_panel.instantiate()

	c1.unit = shared_dict.get("Unit")
	c2.unit = shared_dict.get("Target")

	menu.add_child(c1)
	menu.add_child(c2)
	await interact(c1, c2)
	

func state_exit():
	menu.hide()
	for c in menu.get_children():
		c.queue_free()
	
func state_update():
	pass

func interact(aggressor: CombatPanel, target: CombatPanel):

	await aggressor.volley(target)
	if target.unit.stats.hp > 0: 
		await target.volley(aggressor)
	await get_tree().create_timer(0.3).timeout

	if aggressor.unit: aggressor.unit.exhausted = true
	transitioned.emit(self, "StateMapLook")
