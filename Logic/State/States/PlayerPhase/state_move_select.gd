# State for when friendly unit is selected.
class_name StateMoveSelect
extends State

"""
Needs access to:
- Way to do BFS/Djikstra's
- Unit (so it can tell to move)
- Map
- Pathing arrow and move/attack range.
"""

@onready var move_attack_highlight : MoveAttackHighlight = $MoveAttackHighlight
@onready var path_arrow : PathArrow = $PathArrow

var cursor : Cursor
var walkable : Array
var tm : TileManager
var unit: Unit

func state_enter():
	
	unit = shared_dict.get("Unit")
	tm = shared_dict.get("TileManager")

	cursor = shared_dict.get("Cursor")
	cursor.show()

	walkable = move_attack_highlight.show_range(unit, tm) 
	path_arrow.show_arrow(unit.position, walkable, tm)

	# BFS of the area using selected unit's move.
	# Display range of move/attack. Spawn pathing arrow.

func state_exit():
	path_arrow.reset()
	cursor.hide()
	move_attack_highlight.reset()

func state_update():
	if Input.is_action_just_pressed("Cancel"):
		transitioned.emit(self, "StateMapLook")
	if Input.is_action_just_pressed("Select"):
		if path_arrow.path.size() == 1:
			transitioned.emit(self, "StatePostMoveMenu")
			shared_dict["OldPosition"] = unit.position
		var destination = path_arrow.local_to_map(cursor.position)
		if tm.get_unit_at_cell(destination): return
		if destination in walkable:
			if path_arrow.path.size() > 1:
				shared_dict["OldPosition"] = unit.position
				unit.set_path(path_arrow.path, tm)
				transitioned.emit(self, "StateUnitMoving")		

