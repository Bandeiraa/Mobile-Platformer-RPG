extends Area2D

var item_reference = null

func _on_LootRange_body_entered(body):
	print(body.item_name)
	print(body.item_type)
	body.queue_free()
