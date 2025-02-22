# State for after you moved a unit - now, what to do with it?
class_name StatePostMoveMenu
extends State

"""
Needs:
 - What unit can do. So...
 - Unit.
 - Map, to see stuff in unit's attack range.
 - Way to hook up buttons to what unit can do.
 """

var unit : Unit
var tm : TileManager

func state_enter() -> void:
	unit = shared_dict.get("Unit")
	tm = shared_dict.get("TileManager")
	
	if tm.get_attackable_targets(unit).size() == 0:
		$PostMoveMenu/VBoxContainer.find_child("Attack").hide()
	else:
		$PostMoveMenu/VBoxContainer.find_child("Attack").show()

	$PostMoveMenu.show()

	for b: Button in $PostMoveMenu/VBoxContainer.get_children():
		if 		b.name == "Attack": b.connect("pressed", _on_attack_pressed)
		elif	b.name == "Wait": b.connect("pressed", _on_wait_pressed)
		elif 	b.name == "Options": b.connect("pressed", _on_options_pressed)


func state_exit() -> void:

	$PostMoveMenu.hide()

func state_update() -> void:
	# maybe check for input?
	if Input.is_action_just_pressed("Cancel"):
		unit.position = shared_dict.get("OldPosition")
		transitioned.emit(self, "StateMoveSelect")
	

func _on_attack_pressed() -> void:
	transitioned.emit(self, "StateWeaponSelect")

func _on_wait_pressed() -> void:
	unit.exhausted = true
	transitioned.emit(self, "StateMapLook")

func _on_options_pressed() -> void:
	print("Options pressed... this does NOTHING!!!")