class_name CombatForecast
extends CenterContainer



func fill_info(unit: Unit, target: Unit):
    %UnitName.text = str(unit.name)
    %HPCounter.text = str(unit.stats.hp)
    %MaxHPCounter.text = str(unit.stats.max_hp)
    %StrengthCounter.text = str(unit.stats.strn)
    %DefenseCounter.text = str(unit.stats.def)
    %HitChanceCounter.text = str(unit.stats.hit_chance)
    %DamageCounter.text = str(maxi(unit.stats.strn - unit.stats.def, 0))
