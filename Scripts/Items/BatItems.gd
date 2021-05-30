extends "res://Scripts/Items/Items.gd"

func _ready():
	items_list = [load("res://Scenes/Items/Bat/BatTooth.tscn"), load("res://Scenes/Items/Bat/BatWing.tscn"), load("res://Scenes/Items/Bat/BatHat.tscn")]
	
	
func drop():
	for item in items_list:
		var random_value = get_random_value()
		var new_item = item.instance()
		if random_value <= new_item.drop_rate:
			new_item.position = get_parent().global_position
			get_tree().root.call_deferred("add_child", new_item)
