extends Position2D

signal camera_shake

onready var arrow = preload("res://Scenes/Actors/Arrow.tscn")

func _spawn_arrow():
	emit_signal("camera_shake")
	var arrow_instanced = arrow.instance()
	get_tree().get_root().add_child(arrow_instanced)
	arrow_instanced.position = self.global_position
	if sign(self.position.x) == 1:
		arrow_instanced.set_arrow_direction(1)
	else:
		arrow_instanced.set_arrow_direction(-1)
		
		
func arrow_direction():
	if Input.is_action_pressed("ui_left"):
		if sign(self.position.x) == 1:
			self.position.x *= -1
			
	if Input.is_action_pressed("ui_right"):
		if sign(self.position.x) == -1:
			self.position.x *= -1
