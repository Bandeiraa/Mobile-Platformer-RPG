extends KinematicBody2D

signal can_interact
signal cannot_interact

onready var quest_icon = get_node("QuestIconSpawner")

var dialogue_json = "res://Resources/Quest_01_Start.json"
var dialogue_flag = false

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and dialogue_flag:
		get_tree().call_group("HUD", "call_dialogue", dialogue_json)
		dialogue_flag = false
		kill_dialog_path()
		get_tree().paused = true
		
		
func _on_DetectionZone_body_entered(_body):
	if dialogue_json != null:
		dialogue_flag = true
		quest_icon.show()
		emit_signal("can_interact", dialogue_json)


func _on_DetectionZone_body_exited(_body):
	dialogue_flag = false
	quest_icon.hide()
	emit_signal("cannot_interact")
	
	
func kill_dialog_path():
	quest_icon.hide()
	dialogue_json = null
