extends Control

onready var life_bar = get_node("LifeBar")
onready var life_bar_aux = get_node("LifeBarAux")
onready var update_health_tween = get_node("Tween")

func update_hp(new_hp):
	life_bar.value = new_hp * 20
	update_health_tween.interpolate_property(life_bar_aux, "value", life_bar_aux.value, new_hp * 20, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_health_tween.start()
