extends AnimatedSprite

func _on_Player_move(input_vector, on_floor):
	get_orientation(input_vector)
	if input_vector.x != 0 and on_floor:
		play("Run")
	elif input_vector.y != 0:
		return play("Jump") if input_vector.y < 0 else play("Fall")
	else:
		play("Idle")
		
		
func get_orientation(input):
	if input.x > 0:
		flip_h = false
	elif input.x < 0:
		flip_h = true
