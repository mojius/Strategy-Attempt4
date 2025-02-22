## The state corresponding to when you can just... look around the map at enemies.
class_name StateMapLook
extends State

""" 
Needs access to:
- Cursor
- Input scanning
- Map, I guess?
- The unit at wherever it tries to select, if there is one
"""

var cursor : Cursor
var tm : TileManager

func state_enter():
	# Make sure cursor is being displayed
	cursor = shared_dict.get("Cursor")
	tm = shared_dict.get("TileManager")
	cursor.show()

func state_exit():
	cursor.hide()

func state_update():
	if Input.is_action_just_pressed("Select"):
		var selected_unit = tm.get_unit_at_cell(tm.local_to_map(cursor.position))
		if selected_unit and selected_unit is Unit and not selected_unit.exhausted and selected_unit.faction == selected_unit.Faction.Blue:
			shared_dict.set("Unit", selected_unit)
			transitioned.emit(self, "StateMoveSelect")
