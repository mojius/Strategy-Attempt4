class_name State
extends Node

signal transitioned(state: State, new_state_name: String)

var shared_dict : Dictionary

func state_enter():
	pass

func state_exit():
	pass

func state_update():
	pass

func state_physics_update():
	pass