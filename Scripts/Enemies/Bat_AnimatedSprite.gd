extends AnimatedSprite

func _direction(direction):
	if direction > 0:
		flip_h = true
	elif direction < 0:
		flip_h = false
