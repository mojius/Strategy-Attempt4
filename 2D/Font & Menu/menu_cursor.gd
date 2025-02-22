class_name MenuCursor
extends Sprite2D

@export var v_box: VBoxContainer
var num_options: int = 0
var options: Array = []

func _ready():
	await v_box.ready
	position.y = v_box.get_child(0).position.y + 8

func _process(delta: float) -> void:
		for b: Button in v_box.get_children():
			if b.is_hovered():
				position.y = b.position.y + 8
