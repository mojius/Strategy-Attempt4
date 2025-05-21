# State- weapon/staff/etc decided. Who do you target, and what does it look like to target them?
class_name StateTargetSelectInfo
extends State

@export var target_button: PackedScene

func state_enter():
	# Pull unit and target data and display on screen. Run the numbers.
	var unit = shared_dict.get("Unit")
	var tm = shared_dict.get("TileManager")
	
	$TargetSelectInfoMenu.show()
	for target in tm.get_attackable_targets(unit):
		var b: TargetButton = target_button.instantiate()
		$TargetSelectInfoMenu/VBoxContainer.add_child(b)
		b.unit = target
		b.text = target.name
		b.connect("pressed", _on_target_button_pressed.bind(b.unit))

func state_exit():
	$TargetSelectInfoMenu.hide()
	for c in $TargetSelectInfoMenu/VBoxContainer.get_children():
		c.queue_free()

	pass

func state_update():
	if Input.is_action_just_pressed("Cancel"):
		transitioned.emit(self, "StateWeaponSelect")

func _on_target_button_pressed(target: Unit):
	shared_dict["Target"] = target
	transitioned.emit(self, "StateUnitsCombat")
	