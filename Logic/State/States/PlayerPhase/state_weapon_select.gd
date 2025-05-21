# State- you decided to attack or assist (with staff) an enemy. What will you use for that?
class_name StateWeaponSelect
extends State

func state_enter():
	# Show the menu, hook up the buttons. 
	# Maybe all buttons do the same thing, and your menu option just determines the set variable.
	$WeaponSelectMenu.show()
	var b1 = Button.new()
	b1.text = "Sword"
	var b2 = Button.new()
	b2.text = "Wand"
	b1.connect("pressed", on_any_button_pressed)
	b2.connect("pressed", on_any_button_pressed)
	$WeaponSelectMenu/VBoxContainer.add_child(b1)
	$WeaponSelectMenu/VBoxContainer.add_child(b2)

func state_exit():
	# Hide the menu.
	$WeaponSelectMenu.hide()
	for b: Button in $WeaponSelectMenu/VBoxContainer.get_children():
		b.queue_free()
	pass

func state_update():
	# maybe check for input?
	if Input.is_action_just_pressed("Cancel"):
		transitioned.emit(self, "StatePostMoveMenu")

# Placeholder
func on_any_button_pressed():
	transitioned.emit(self, "StateTargetSelectInfo")