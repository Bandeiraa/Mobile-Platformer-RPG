extends KinematicBody2D

signal can_interact
signal cannot_interact

onready var quest_icon = get_node("QuestIconSpawner")

var dialog_path = "res://Resources/Quest_01.json"

func _on_DetectionZone_body_entered(_body):
	quest_icon.show()
	emit_signal("can_interact", dialog_path)


func _on_DetectionZone_body_exited(_body):
	quest_icon.hide()
	emit_signal("cannot_interact")
