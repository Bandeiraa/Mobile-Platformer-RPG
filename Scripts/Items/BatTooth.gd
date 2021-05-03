extends "res://Scripts/Items/ItemTemplate.gd"

var gravity = 250
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)
