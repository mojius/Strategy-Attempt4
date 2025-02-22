class_name CPUPhase
extends Node

@onready var red_units: Node2D = get_node("%Units").find_child("Red")
@onready var green_units: Node2D = get_node("%Units").find_child("Green")
	
func run_red():
	for unit: Unit in red_units.get_children():
		await unit.run_behavior()

func run_green():
	for unit: Unit in green_units.get_children():
		await unit.run_behavior()
