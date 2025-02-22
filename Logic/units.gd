class_name Units
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in get_children():
		for unit: Unit in n.get_children():
			if n.name == "Green":
				unit.faction = unit.Faction.Green
			elif n.name == "Blue":
				unit.faction = unit.Faction.Blue
			elif n.name == "Red":
				unit.faction = unit.Faction.Red

## Checks faction allyship. Blues and Greens oppose Reds, Reds oppose Blues and Greens. 
## Otherwise, like faction-units support each other.
func opposes_faction(source: int, target: int):
	if (source == 0 or source == 2) and target == 1: return true
	elif source == 1 and (target == 0 or target == 2): return true
	else: return false

func refresh_units():
	for n in get_children():
		for unit: Unit in n.get_children():
			unit.exhausted = false

func get_all_units_in_faction(faction: int) -> Array:
	if faction == 0: return find_child("Blue").get_children()
	if faction == 1: return find_child("Red").get_children()
	if faction == 2: return find_child("Green").get_children()
	else:
		print("get_all_units_in_faction: invalid faction value!")
		return []