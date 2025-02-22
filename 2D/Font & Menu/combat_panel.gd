class_name CombatPanel
extends CenterContainer

var unit: Unit
@export var pellet: PackedScene
@onready var pellet_container = $Container1/MarginContainer/VBoxContainer/PelletContainer
@onready var text_container = $Container1/MarginContainer/VBoxContainer/TextContainer
@onready var unit_name = $Container1/MarginContainer/VBoxContainer/TextContainer/UnitName
@onready var max_hp_counter = $Container1/MarginContainer/VBoxContainer/TextContainer/MaxHPCounter 
@onready var hp_counter = $Container1/MarginContainer/VBoxContainer/TextContainer/HPCounter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !unit:
		return
	
	for i in range(0, unit.stats.max_hp):
		var p = pellet.instantiate()
		pellet_container.add_child(p)
	
	max_hp_counter.text = str(unit.stats.max_hp)
	unit_name.text = unit.name

func _process(_delta: float) -> void:
	if !unit: return
	# Fill with health
	var health: int = unit.stats.hp
	for pel : HealthPellet in pellet_container.get_children():
		if health > 0:
			pel.texture = pel.full_pellet
			health -= 1
		else: pel.texture = pel.empty_pellet
	
	hp_counter.text = str(unit.stats.hp)

func volley(target: CombatPanel):
	if unit.stats.hp <= 0 or target.unit.stats.hp <= 0: return

	await get_tree().create_timer(0.5).timeout
	
	# Some offset tomfoolery here
	var source_pos := unit.position
	var dest_direction := source_pos.direction_to(target.unit.position) * 8
	var source_offset := unit.offset
	
	# Going towards the unit
	var towards_tween = unit.create_tween()
	towards_tween.tween_property(unit, "offset", source_offset + dest_direction, 0.2).from(unit.offset).set_trans(Tween.TRANS_BACK)
	await towards_tween.finished

	var damage = unit.stats.strn - target.unit.stats.def

	shake_unit(target.unit)

	# Going away from the unit
	var return_tween = unit.create_tween()
	return_tween.tween_property(unit, "offset", source_offset, 0.2).from(source_offset + dest_direction).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	target.change_hp(damage)
	await return_tween.finished
	
	await target.check_dead()

func change_hp(difference: int):

	var pellets = pellet_container.get_children()
	pellets.reverse()
	while difference > 0:
			unit.stats.hp -= 1 	
			difference -= 1
			await get_tree().create_timer(0.02).timeout
	

func check_dead():
	if unit.stats.hp <= 0:
		await get_tree().create_timer(0.5).timeout
		await unit.die()
	
func shake_unit(target: Unit):

	var shake_count := 32	
	var original_offset := target.offset
	var shake_amount
	while shake_count > 0:
		shake_amount = shake_count * 0.1
		var tw := target.create_tween()
		tw.tween_property(target, "offset", original_offset + Vector2(int(randf() * shake_amount), int(randf() * shake_amount)), 0.01)
		await tw.finished
		shake_count -= 1
	target.offset = original_offset
