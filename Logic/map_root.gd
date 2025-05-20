extends Node2D

@onready var phase_scene: PackedScene = preload("res://2D/Menu/PhaseAnimation.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var phase_animator = phase_scene.instantiate()
	add_child(phase_animator)
	$Cursor.tile_manager = $TileManager
	while true:

		await player_phase(phase_animator)
		await enemy_phase(phase_animator)
		await ally_phase(phase_animator)

func _process(_delta) -> void:
	if %Units.find_child("Blue").get_child_count() == 0: get_tree().quit()

func player_phase(phase_animator):
		await phase_animator.play(0)
		get_tree().create_timer(0.5)
		%Units.refresh_units()
		$PlayerPhase.run()
		await $PlayerPhase.turn_ended
		get_tree().create_timer(0.5)


func enemy_phase(phase_animator):
		await phase_animator.play(1)
		get_tree().create_timer(0.5)
		%Units.refresh_units()
		await $CPUPhase.run_red()
		get_tree().create_timer(0.5)

func ally_phase(phase_animator):
		await phase_animator.play(2)
		get_tree().create_timer(0.5)
		%Units.refresh_units()
		await $CPUPhase.run_green()
		get_tree().create_timer(0.5)
