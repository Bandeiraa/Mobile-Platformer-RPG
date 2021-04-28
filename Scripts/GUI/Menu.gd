extends Control

var _change_scene

func _on_NewGameButton_pressed():
	_change_scene = get_tree().change_scene("res://Scenes/Levels/TemplateLevel.tscn")


func _on_ExitGameButton_pressed():
	get_tree().quit()
