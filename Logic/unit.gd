class_name Unit
extends AnimatedSprite2D

enum Faction { Blue, Red, Green }
var faction: Faction = Faction.Blue

## Move speed during pathfinding.
@export var move_speed: float = 1.0

## The Unit's stats (health, move range, etc.)
@export var stats: StatsResource

var exhausted: bool = false:
	set(value):
		if value == true:
			$AnimationPlayer.play("exhaust")
		else:
			$AnimationPlayer.play("RESET")
		exhausted = value
var _path: Array

var _path_progress: float = 0
var _path_index: int = 0

var tm : TileManager

signal finished_walking


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _path != []: follow_path(delta)

func follow_path(delta: float):

	if _path.size() <= 1: return
	var rate = 6 * delta
	
	var current: Vector2 = tm.map_to_local(_path[_path_index]) - Vector2(8,8)
	var target: Vector2 = tm.map_to_local(_path[_path_index + 1]) - Vector2(8,8)

	var next_pos: Vector2 = lerp(current, target, _path_progress)

	if (_path_progress < 1):
		position = next_pos
		_path_progress += rate
	else:
		position = target
		_path_index += 1
		_path_progress -= 1
		if _path_index + 1 >= _path.size(): 

			finished_walking.emit()
			_path = []
			_path_index = 0
			_path_progress = 0

func set_path(path: Array, tile_manager: TileManager):
	_path = path
	if tile_manager: tm = tile_manager


func die():
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()
	