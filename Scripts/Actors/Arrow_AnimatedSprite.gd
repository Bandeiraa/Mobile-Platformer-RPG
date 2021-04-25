extends AnimatedSprite

signal destroy

func _on_Arrow_animate(direction):
	play("Idle")
	if direction > 0:
		flip_h = false
	elif direction < 0:
		flip_h = true


func _on_Arrow_hit_animation():
	play("Hit")
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("destroy")
