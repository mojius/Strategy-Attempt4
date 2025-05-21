class_name CombatForecastMenu
extends HBoxContainer

@onready var combat_forecast_object = preload("res://2D/Menu/CombatForecast.tscn")

var cf1: CombatForecast
var cf2: CombatForecast

func forecast(attacker: Unit, target: Unit) -> void:
	cf1 = combat_forecast_object.instantiate()
	cf2 = combat_forecast_object.instantiate()
	add_child(cf1)
	add_child(cf2)
	cf1.fill_info(attacker, target)
	cf2.fill_info(target, attacker)


func wipe_forecasts():
	cf1.queue_free()
	cf2.queue_free()
