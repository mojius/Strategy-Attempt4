class_name TestState2
extends State

var timer = 60

func state_enter():
	timer = 60
	# BFS of the area using selected unit's move.
	# Display range of move/attack. Spawn pathing arrow.
	print("Hello -- entering TWO!")

func state_exit():
	print("Hello -- exiting TWO!!")

func state_update():
	# Update path arrow. Range shouldn't be changing. Check for click input (mouse)
	print("Hello -- updating TWO!!")
	timer -= 1
	if timer < 0:
		transitioned.emit(self, "TestState1")