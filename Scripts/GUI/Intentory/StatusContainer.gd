extends Control

onready var strength_label = get_node("StrengthLabel")
onready var health_label = get_node("HealthLabel")

func set_status_text(current_attack, total_health):
	strength_label.text = "Força: " + str(current_attack)
	health_label.text = "Vida: " + str(total_health)
