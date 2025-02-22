## A state machine for the field menus.
class_name PlayerPhase
extends StateMachine

@onready var blue_units: Node2D = get_node("%Units").find_child("Blue")

signal turn_ended
	
func _ready() -> void:  
	# Deal with cursor/refactor later
	var map_root = get_tree().root.get_child(0)
	shared_dict["Cursor"] = map_root.find_child("Cursor")
	shared_dict["TileManager"] = %TileManager
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	var done = true
	for unit: Unit in blue_units.get_children():
		if unit.exhausted == false: done = false
	if done: 
		turn_ended.emit()
		shared_dict["Cursor"].hide()
		current_state = null
