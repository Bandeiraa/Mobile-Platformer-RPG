extends Area2D

signal send_dropped_item

var item_reference = null

func _on_LootRange_body_entered(body):
	emit_signal("send_dropped_item", body)
	body.queue_free()
