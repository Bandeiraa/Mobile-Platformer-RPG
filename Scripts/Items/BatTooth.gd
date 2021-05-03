extends "res://Scripts/Items/ItemTemplate.gd"

var gravity = 250
var velocity = Vector2()

func _physics_process(delta):
	if is_on_floor():
		velocity = move_and_slide(Vector2.ZERO, Vector2.UP)
		
	else:
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity)
