extends GridContainer

onready var default_texture = load("res://Sprites/UI/Empty_Inventory_Slot.png")
onready var in_use_slot_texture = load("res://Sprites/UI/Filled_Inventory_Slot.png")
onready var bat_items = [load("res://Sprites/Items/Bat/Bat_Tooth.png"), load("res://Sprites/Items/Bat/Bat_Wings.png")]

func _ready():
	randomize()
	spawn_child()
	
	
func spawn_child():
	for children_slot in get_children().size():
		var choosen_item = randi() % 2
		var new_texture = TextureRect.new()
		new_texture.texture = bat_items[choosen_item]
		new_texture.rect_min_size = Vector2(14, 14)
		new_texture.rect_position = Vector2(2, 2)
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		get_child(children_slot).add_child(new_texture)
		set_texture()
		
		
func set_texture():
	for slot in get_children():
		if slot.get_children() == []:
			slot.texture = default_texture
		else:
			slot.texture = in_use_slot_texture
