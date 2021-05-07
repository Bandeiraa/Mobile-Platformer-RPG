extends GridContainer

signal items_changed

onready var default_texture = load("res://Sprites/UI/Empty_Inventory_Slot.png")
onready var in_use_texture = load("res://Sprites/UI/Filled_Inventory_Slot.png")

var busy_slots = 0
var items: Array = [[null], [null], [null], [null], [null], [null], [null], [null]]
var item_index

func _ready():
	randomize()
	for slot in get_children():
		slot.connect("mouse_entered", self, "get_item_index", [slot.get_index()])
		
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
		var label = Label.new()
		var item_name = item.item_name
		var item_amount = item.item_amount
		new_texture.texture = item.item_texture
		new_texture.rect_min_size = Vector2(14, 14)
		new_texture.rect_position = Vector2(2, 2)
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		label.text = str(item_amount)
		label.rect_min_size = Vector2(6, 6)
		label.valign = Label.VALIGN_CENTER
		label.align = Label.ALIGN_CENTER
		label.rect_position = Vector2(12, 12)
		get_child(choosen_item).add_child(new_texture)
		get_child(choosen_item).add_child(label)
		get_child(choosen_item).get_item_info(item.item_name)
		items[choosen_item] = [new_texture, item_name, item_amount]
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
		if items[index] == [null]:
			get_children()[index].reset_slot_info()
			slots -= 1
			
	busy_slots = slots
		
		
func get_item_index(index):
	item_index = index
	
	
func get_drag_data(_position):
	var current_slot = get_child(item_index)
	var current_slot_children = current_slot.get_children()
	if current_slot_children != []:
		var item_texture = current_slot.get_child(0).texture
		var item_name = items[item_index][1]
		var item_amount = items[item_index][2]
		
		remove_item(item_index)
		var data = {}
		data.item = item_texture
		data.item_name = item_name
		data.item_amount = item_amount
		data.item_index = item_index
		var drag_preview = TextureRect.new()
		drag_preview.texture = data.item
		set_drag_preview(drag_preview)
		set_texture()
		return data
	
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
	
func drop_data(_position, data):
	set_item(item_index, data.item, data.item_name, data.item_amount)
	
	
func set_item(index, item_texture, item_name, item_amount):
		var current_slot = get_child(index)
	#if items[index] == null:
	#	if item_name == items[index][1]:
	#		items[index][2] += item_amount
	#		current_slot.get_child(1).text = items[index][2]
	#		
	#else:
		var new_texture = TextureRect.new()
		var label = Label.new()
		new_texture.texture = item_texture
		new_texture.rect_min_size = Vector2(14, 14)
		new_texture.rect_position = Vector2(2, 2)
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		label.text = str(item_amount)
		label.rect_min_size = Vector2(6, 6)
		label.valign = Label.VALIGN_CENTER
		label.align = Label.ALIGN_CENTER
		label.rect_position = Vector2(12, 12)
		current_slot.add_child(new_texture)
		current_slot.add_child(label)
		current_slot.get_item_info(item_name)
		items[index] = [item_texture, item_name, item_amount]
		set_texture()
	
	
func swap_items(index, target_item_index):
	var target_item = items[target_item_index]
	var item = items[index]
	items[target_item_index] = item
	items[index] = target_item
	#emit_signal("items_changed", [index, target_item_index])
	
	
func remove_item(index):
	if items != []:
		var previous_item = items[index]
		items[index] = [null]
		emit_signal("items_changed", index)
		return previous_item
		
		
func items_changed(index):
	#get_children()[index].get_child(0).queue_free()
	for children in get_children()[index].get_children():
		children.queue_free()
		
	set_texture()
		
		
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse_button"):
		set_texture()
