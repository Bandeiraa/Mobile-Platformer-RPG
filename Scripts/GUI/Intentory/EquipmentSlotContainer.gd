extends GridContainer

var item_index

func _ready():
	for slot in get_children():
		slot.connect("mouse_entered", self, "get_item_index", [slot.get_index()])
		
		
func get_item_index(index):
	item_index = index
	
	
func can_drop_data(_position, data):
	if get_child(item_index).equipment_slot_type == data["item_type"]:
		return data
		
		
func drop_data(_position, data):
	set_item(data.item_image, data.item_name, data.item_type)
	
	
func set_item(item_image, _item_name, _item_type):
	var current_slot = get_child(item_index)
	var equipment_image = current_slot.get_node("ItemTextureRect")
	equipment_image.texture = item_image
	current_slot.slot_occuped = true
