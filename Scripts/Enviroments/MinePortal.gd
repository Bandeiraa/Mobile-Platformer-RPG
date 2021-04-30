extends "res://Scripts/Enviroments/Portal.gd"

func _on_MinePortal_body_entered(body):
	print(body.name + " entrou na área do portal")


func _on_MinePortal_body_exited(body):
	print(body.name + " saiu da área do portal")
