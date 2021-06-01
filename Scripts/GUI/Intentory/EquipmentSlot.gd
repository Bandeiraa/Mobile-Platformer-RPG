extends Node
class_name EquipmentSlotManager

export var equipment_slot_type = ""
export var slot_occuped = false
export var item_name = ""
export var item_type = ""
export var item_health = 0
export var item_attack = 0

func reset_slot_info():
	slot_occuped = false
