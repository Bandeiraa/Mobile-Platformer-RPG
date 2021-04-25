extends StaticBody2D

func disable_collision():
	get_node("CollisionShape2D").disabled = true
	
	
func enable_collision():
	get_node("CollisionShape2D").disabled = false
