extends KinematicBody2D

signal can_interact
signal cannot_interact

onready var quest_icon = get_node("QuestIconSpawner")

var quest_monster_type = "Morcego"
var amount = 7

var dialogue_json = "res://Resources/Quest_02_Start.json"
var dialogue_json_endQuest = "res://Resources/Quest_02_End.json"

var interact = false
var end_quest_flag = false
var type

func _process(_delta):
	if end_quest_flag and Input.is_action_just_pressed("Interact") and interact:
		type = "ending"
		get_tree().call_group("HUD", "call_dialogue", dialogue_json_endQuest, type)
		interact = false
		quest_icon.hide()
		dialogue_json_endQuest = null
		get_tree().paused = true
		
	elif Input.is_action_just_pressed("Interact") and interact:
		type = "initializing"
		get_tree().call_group("HUD", "call_dialogue", dialogue_json, type)
		interact = false
		quest_icon.hide()
		dialogue_json = null
		get_tree().paused = true
		
		
func _on_DetectionZone_body_entered(_body):
	if end_quest_flag and dialogue_json_endQuest != null:
		interact = true
		quest_icon.show()
		
	elif dialogue_json != null:
		interact = true
		quest_icon.show()
		emit_signal("can_interact", dialogue_json)


func _on_DetectionZone_body_exited(_body):
	interact = false
	quest_icon.hide()
	emit_signal("cannot_interact")
	
	
func can_finish_quest():
	end_quest_flag = true
	quest_icon.show()
