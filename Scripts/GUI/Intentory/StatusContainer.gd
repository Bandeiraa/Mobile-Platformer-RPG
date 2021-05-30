extends Control

signal send_bonus_status

onready var strength_label = get_node("StrengthLabel")
onready var health_label = get_node("HealthLabel")
onready var strength_label_bonus = get_node("StrengthLabelAux")
onready var health_label_bonus = get_node("HealthLabelAux")

var bonus_health = 0
var bonus_attack = 0

func set_status_text(current_attack, total_health):
	strength_label.text = "Força: " + str(current_attack)
	health_label.text = "Vida: " + str(total_health)
	
	
func update_status(health_bonus, attack_bonus):
	bonus_health += health_bonus
	bonus_attack += attack_bonus
	verify_attributes(bonus_health, bonus_attack)
	
	
func verify_attributes(health_bonus, attack_bonus):
	if health_bonus > 0:
		update_text("health_bonus", " +", Color(0, 1, 0, 1), health_bonus)
		
	elif health_bonus < 0:
		update_text("health_bonus", "", Color(1, 0, 0, 1), health_bonus)
		
	if attack_bonus > 0:
		update_text("attack_bonus", " +", Color(0, 1, 0, 1), attack_bonus)
		
	elif attack_bonus < 0:
		update_text("attack_bonus", "", Color(1, 0, 0, 1), attack_bonus)
		
	emit_signal("send_bonus_status", health_bonus, attack_bonus)
		 
		
func update_text(target, operator, color, bonus_amount):
	match target:
		"health_bonus":
			health_label_bonus.add_color_override("font_color", color)
			health_label_bonus.text =  operator + str(bonus_amount)
			
			
		"attack_bonus":
			strength_label_bonus.add_color_override("font_color", color)
			strength_label_bonus.text =  operator + str(bonus_amount)
