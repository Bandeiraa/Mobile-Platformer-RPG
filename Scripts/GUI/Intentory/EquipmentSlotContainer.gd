extends GridContainer

var item_index = 0

signal item_equipped
signal swap_items
signal exited_equip_area
signal entered_equip_area

func _ready():
	for slot in get_children():
		slot.connect("mouse_entered", self, "get_item_index", [slot.get_index()])
		
		
func get_item_index(index):
	item_index = index
	
	
func can_drop_data(_position, data):
	var children = get_child(item_index)
	if children.equipment_slot_type == data["item_type"] and children.item_name != data["item_name"]:
		return data
		
		
func drop_data(_position, data):
	set_item(data.item_image, data.item_name, data.item_type, data.item_health,
	 data.item_attack, data.item_index)
	
	
func set_item(item_image, item_name, item_type, item_health, item_attack, index):
	var current_slot = get_child(item_index)
	var equipment_image = current_slot.get_node("ItemTextureRect")
	
	if current_slot.item_name != "":
		emit_signal("swap_items", equipment_image.texture, current_slot.item_name, current_slot.item_type,
		 current_slot.item_health, current_slot.item_attack, index)
		
		equip_item(current_slot, equipment_image, item_image, item_name, item_type, item_health, item_attack)
		
	else:
		equip_item(current_slot, equipment_image, item_image, item_name, item_type, item_health, item_attack)
		
	emit_signal("item_equipped", item_health, item_attack)
	
	
func equip_item(current_slot, equipment_image, item_image, item_name, item_type, item_health, item_attack):
	equipment_image.texture = item_image
	current_slot.item_name = item_name
	current_slot.item_type = item_type
	current_slot.item_health = item_health
	current_slot.item_attack = item_attack
	current_slot.slot_occuped = true


func mouse_entered():
	emit_signal("entered_equip_area")


func mouse_exited():
	emit_signal("exited_equip_area")
