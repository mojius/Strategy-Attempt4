@tool
class_name StatsResource
extends Resource

@export var move_range: int = 5
@export var min_atk_range: int = 1
@export var max_atk_range: int = 1
@export var max_hp: int = 20
@export var hp := 20 :
    set(value):
        hp = clampi(0, value, max_hp)
        
@export var strn: int = 10
@export var def: int = 6


func _init() -> void:
    resource_local_to_scene = true