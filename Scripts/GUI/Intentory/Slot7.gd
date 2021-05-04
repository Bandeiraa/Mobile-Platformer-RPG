extends TextureRect

var item_name = ""
var item_amount = 0
var slot_occuped = false

func get_item_info(received_item_name):
	item_name = received_item_name
	slot_occuped = true
