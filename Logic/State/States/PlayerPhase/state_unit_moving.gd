# State for when friendly unit is selected.
class_name StateUnitMoving
extends State

"""
Basically just waiting for unit to finish moving.
"""

var cursor : Cursor
var walkable : Array
var tm : TileManager
var unit: Unit

func state_enter():
	unit = shared_dict.get("Unit")


func state_exit():
	pass


func state_update():
	await unit.finished_walking
	transitioned.emit(self, "StatePostMoveMenu")
