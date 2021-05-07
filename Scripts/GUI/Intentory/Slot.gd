extends TextureRect
class_name SlotManager

var item_name = ""
var item_amount = 0
var slot_occuped = false

func get_item_info(_received_item_name):
	pass
	
	
func reset_slot_info():
	item_name = ""
	item_amount = 0
	slot_occuped = false
