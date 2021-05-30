extends TextureRect
class_name SlotManager

var item_name = ""
var item_type = ""
var health_bonus = 0
var attack_bonus = 0
var item_amount = 0
var slot_occuped = false

func _ready():
	get_node("ItemAmount").text = ""
	
	
func get_item_info(_received_item_name, _received_item_amount, _received_item_type, _received_health_bonus, _received_attack_bonus):
	pass
	
	
func reset_slot_info():
	item_name = ""
	item_type = ""
	item_amount = 0
	attack_bonus = 0
	health_bonus = 0
	slot_occuped = false
	
	
func increase_amount(amount):
	item_amount += amount
	get_node("ItemAmount").text = str(item_amount)
