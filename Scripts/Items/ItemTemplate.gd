extends KinematicBody2D

export (float) var drop_rate #Value between 0.0 to 100.0
export (String) var item_name #Item name
export (String) var item_type #Item type e.g. Resource, Equipment etc
export (int) var item_amount

func _on_Item_area_entered(_area):
	pass # Replace with function body.


func _on_Item_area_exited(_area):
	pass # Replace with function body.
