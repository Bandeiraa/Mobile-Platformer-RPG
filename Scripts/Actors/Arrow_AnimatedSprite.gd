extends AnimatedSprite

signal destroy

var destroy_flag = false

func _on_Arrow_animate(direction):
	play("Idle")
	if direction > 0:
		flip_h = false
	elif direction < 0:
		flip_h = true


func _on_Arrow_hit_animation():
	play("Hit")
	destroy_flag = true


func _on_AnimatedSprite_animation_finished():
	if destroy_flag:
		emit_signal("destroy")
		destroy_flag = false
