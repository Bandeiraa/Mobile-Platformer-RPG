extends GridContainer

onready var default_texture = load("res://Sprites/UI/Empty_Inventory_Slot.png")
onready var in_use_texture = load("res://Sprites/UI/Filled_Inventory_Slot.png")

var busy_slots = 0
var item_index

func _ready():
	randomize()
	for slot in get_children():
		slot.connect("mouse_entered", self, "get_item_index", [slot.get_index()])
		
	set_texture()
	
	
func get_item(item):
	var chosen_item = randi() % get_children().size()
	var childrens_size = get_children().size()
	var chosen_child = get_child(chosen_item)
	
	if chosen_child.slot_occuped == true:
		if busy_slots < childrens_size:
			return get_item(item)
		else:
			item.queue_free()
		
	else:
		var item_name = item.item_name
		var item_amount = item.item_amount
		var item_type = item.item_type
		chosen_child.get_node("ItemTextureRect").texture = item.item_texture
		chosen_child.get_node("ItemAmount").text = str(item_amount)
		chosen_child.get_item_info(item_name, item_amount, item_type)
		set_texture()
		
		
func set_texture():
	var slots = 0
	for slot in get_children():
		slots += 1
		
		if slot.get_node("ItemTextureRect").texture == null:
			slot.texture = default_texture
			slot.reset_slot_info()
			slots -= 1
			
		else:
			slot.texture = in_use_texture
			
	busy_slots = slots
	
	
func get_item_index(index):
	item_index = index
	
	
func get_drag_data(_position):
	var current_slot = get_child(item_index)
	var item_name = current_slot.item_name
	var amount = current_slot.item_amount
	var item_type = current_slot.item_type
	var image = current_slot.get_node("ItemTextureRect").texture
	if image != null:
		var dictionary = data_dictionary(image, item_name, amount, item_index, item_type)
		drag_preview(image)
		remove_item(item_index)
		
		return dictionary
	
#Fill data dictionary
func data_dictionary(item_image, item_name, item_amount, index, item_type):
	var data = {}
	data.item_image = item_image
	data.item_name = item_name
	data.item_amount = item_amount
	data.item_index = index
	data.item_type = item_type
	return data
	
#Draws a preview of the item being dragged
func drag_preview(preview): 
	var drag_preview = TextureRect.new()
	drag_preview.texture = preview
	set_drag_preview(drag_preview)
	
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item_name")
	
	
func drop_data(_position, data):
	set_item(data.item_image, data.item_name, data.item_amount, data.item_index, data.item_type)
	
	
func set_item(image, previous_item_name, amount, index, previous_item_type):
	#Use index wisely to do verifications
	var current_slot = get_child(item_index)
	var item_label = current_slot.get_node("ItemAmount")
	var item_image = current_slot.get_node("ItemTextureRect")
	var item_amount = item_label.text
	var item_name = current_slot.item_name
	var item_type = current_slot.item_type
	var current_image = item_image.texture

	if current_slot.item_name != "":
		if previous_item_name == item_name:
			current_slot.increase_amount(amount) 
		else:
			var previous_slot = get_child(index)
			previous_slot.get_node("ItemTextureRect").texture = current_image
			previous_slot.get_node("ItemAmount").text = item_amount
			previous_slot.get_item_info(item_name, int(item_amount), item_type)
			
			item_image.texture = image
			item_label.text = str(amount)
			current_slot.get_item_info(previous_item_name, amount, previous_item_type)
		
	else:
		item_image.texture = image
		item_label.text = str(amount)
		current_slot.get_item_info(previous_item_name, amount, previous_item_type)
		
	set_texture()
	
	
func remove_item(index):
	var current_slot = get_child(index)
	current_slot.get_node("ItemAmount").text = ""
	current_slot.get_node("ItemTextureRect").texture = null
	set_texture()
	
	
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse_button"):
		set_texture()
