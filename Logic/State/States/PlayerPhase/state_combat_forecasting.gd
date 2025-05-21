class_name StateCombatForecast 
extends State

@onready var combat_forecast_object = preload("res://2D/Menu/CombatForecast.tscn")

""" 
Needs access to:
- Unit info
- Combat forecast menu (which it has)
- Combat forecast objects to instantiate
"""

var cf1
var cf2

var cursor : Cursor
var tm : TileManager

func state_enter():
    $CombatForecastMenu.show()
    cf1 = combat_forecast_object.instantiate()
    cf2 = combat_forecast_object.instantiate()
    $CombatForecastMenu.add_child(cf1)
    $CombatForecastMenu.add_child(cf2)

    

func state_exit():
    $CombatForecastMenu.hide()
    cf1.queue_free()
    cf2.queue_free()

func state_update():
    if Input.is_action_just_pressed("Select"):
        transitioned.emit("StateUnitsCombat")
    elif Input.is_action_just_pressed("Cancel"):
        transitioned.emit("StatePostMoveMenu")
