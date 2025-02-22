class_name BTNode
extends Node

var blackboard: Dictionary

func run() -> bool:
	await get_tree().create_timer(0.005)
	return false

