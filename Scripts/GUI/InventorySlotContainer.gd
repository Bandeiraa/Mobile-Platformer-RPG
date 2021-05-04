extends GridContainer

onready var default_texture = load("res://Sprites/UI/Empty_Inventory_Slot.png")
onready var in_use_texture = load("res://Sprites/UI/Filled_Inventory_Slot.png")

var busy_slots = 0

func _ready():
	randomize()
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
		set_texture()
		busy_slots += 1
		
		
func set_texture():
	for slot in get_children():
		if slot.get_children() == []:
			slot.texture = default_texture
		else:
			slot.texture = in_use_texture
