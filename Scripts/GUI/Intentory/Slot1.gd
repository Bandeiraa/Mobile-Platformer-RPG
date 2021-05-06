extends TextureRect

signal send_index

var item_name = ""
var item_amount = 0
export var slot_occuped = false

func get_item_info(received_item_name):
	item_name = received_item_name
	slot_occuped = true


func _on_Slot1_mouse_entered():
	emit_signal("send_index", get_index())
