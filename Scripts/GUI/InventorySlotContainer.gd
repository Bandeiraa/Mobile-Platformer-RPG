extends GridContainer

signal items_changed

onready var default_texture = load("res://Sprites/UI/Empty_Inventory_Slot.png")
onready var in_use_texture = load("res://Sprites/UI/Filled_Inventory_Slot.png")

var busy_slots = 0
var items: Array = [null, null, null, null, null, null, null, null]
var item_index

func _ready():
	randomize()
	for slot in get_children():
		slot.connect("send_index", self, "get_item_index")
		
	set_texture()
	
	
func get_item(item):
	var choosen_item = randi() % get_children().size()
	var childrens_size = get_children().size()
	var choosen_child = get_child(choosen_item)
	if choosen_child.slot_occuped == true:
		if busy_slots < childrens_size:
			return get_item(item)
		else:
			item.queue_free()
		
	else:
		var new_texture = TextureRect.new()
		new_texture.texture = item.item_texture
		new_texture.rect_min_size = Vector2(14, 14)
		new_texture.rect_position = Vector2(2, 2)
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		get_child(choosen_item).add_child(new_texture)
		get_child(choosen_item).get_item_info(item)
		items[choosen_item] = new_texture
		set_texture()
		
		
func set_texture():
	for slot in get_children():
		if slot.get_children() == []:
			slot.texture = default_texture
			
		else:
			slot.texture = in_use_texture
			
	var slots = 0
	for index in items.size():
		slots += 1
		if items[index] == null:
			get_children()[index].slot_occuped = false
			slots -= 1
			
	busy_slots = slots
	print(busy_slots)
		
		
func get_item_index(index):
	item_index = index
	
	
func get_drag_data(_position):
	var current_slot = get_child(item_index)
	var current_slot_children = current_slot.get_children()
	if current_slot_children != []:
		var item = current_slot.get_child(0).texture
		remove_item(item_index)
		var data = {}
		data.item = item
		data.item_index = item_index
		var drag_preview = TextureRect.new()
		drag_preview.texture = data.item
		set_drag_preview(drag_preview)
		set_texture()
		return data
	
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
	
func drop_data(_position, data):
	set_item(item_index, data.item)
	
	
func set_item(index, item):
	var current_slot = get_child(index)
	var new_texture = TextureRect.new()
	new_texture.texture = item
	new_texture.rect_min_size = Vector2(14, 14)
	new_texture.rect_position = Vector2(2, 2)
	new_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	current_slot.add_child(new_texture)
	current_slot.get_item_info(item)
	#busy_slots += 1
	items[index] = item
	
	#emit_signal("items_changed", index)
	#set_texture()
	
	
func swap_items(index, target_item_index):
	var target_item = items[target_item_index]
	var item = items[index]
	items[target_item_index] = item
	items[index] = target_item
	#emit_signal("items_changed", [index, target_item_index])
	
	
func remove_item(index):
	if items != []:
		var previous_item = items[index]
		#print(previous_item)
		items[index] = null
		emit_signal("items_changed", index)
		return previous_item
		
		
func items_changed(index):
	get_children()[index].get_child(0).queue_free()
		
		
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse_button"):
		set_texture()
