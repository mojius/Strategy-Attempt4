class_name StateCombatForecasting
extends State


""" 
Needs access to:
- Unit info
- Combat forecast menu (which it has)
- Combat forecast objects to instantiate
"""



var cursor : Cursor
var tm : TileManager

func state_enter():
    var unit: Unit = shared_dict.get("Unit")
    var target: Unit = shared_dict.get("Target")
    $CombatForecastMenu.show()
    $CombatForecastMenu.forecast(unit, target)


func state_exit():
    $CombatForecastMenu.hide()
    $CombatForecastMenu.wipe_forecasts()

func state_update():
    if Input.is_action_just_pressed("Select"):
        transitioned.emit(self, "StateUnitsCombat")
    elif Input.is_action_just_pressed("Cancel"):
        transitioned.emit(self, "StateTargetSelectInfo")
