extends AnimatedSprite

signal turn_physics
signal spawn_arrow

var attack_flag = false

func _on_Player_move(input_vector, on_floor):
	get_orientation(input_vector)
	if not attack_flag:
		if input_vector.x != 0 and on_floor:
			play("Run")
		elif input_vector.y != 0:
			return play("Jump") if input_vector.y < 0 else play("Fall")
		else:
			play("Idle")
			
	else:
		play("Attack")
		
		
func _on_Player_attack():
	attack_flag = true
	
	
func get_orientation(input):
	if input.x > 0:
		flip_h = false
	elif input.x < 0:
		flip_h = true


func _on_animation_finished():
	attack_flag = false
	emit_signal("turn_physics")


func _on_animation_frame_changed():
	if animation == "Attack":
		if frame == 5:
			emit_signal("spawn_arrow")
