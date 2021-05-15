extends Control

signal show_quest
signal kill_quest

onready var person_name = get_node("DialogueBox/Name")
onready var person_image = get_node("DialogueBox/FaceBox/ImageRect")
onready var person_phrase = get_node("DialogueBox/Text")
onready var timer = get_node("Timer")

export var text_speed = 0.05

var dialogue_path
var status_type
var monster
var amount
var photo
var npc_name
var description
var finished = false 
var phrase_index = 0

func get_dialogue(quest_info, dialogue, quest_status, npc_photo):
	dialogue_path = dialogue
	status_type = quest_status
	photo = npc_photo
	monster = quest_info[0]
	amount = quest_info[1]
	npc_name = quest_info[2]
	description = quest_info[3]
	next_phrase()
	
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phrase()
			
		else:
			person_phrase.visible_characters = len(person_phrase.text)
			
			
func next_phrase():
	if phrase_index >= len(dialogue_path):
		queue_free()
		get_tree().paused = false
		match status_type:
			"start_quest":
				emit_signal("show_quest", description, "0", amount, monster)
				
			"end_quest":
				emit_signal("kill_quest", monster, amount)
				
		return

	finished = false
	
	person_name.bbcode_text = npc_name
	person_phrase.bbcode_text = dialogue_path[phrase_index]
	person_phrase.visible_characters = 0
	person_image.texture = photo 
	
	while person_phrase.visible_characters < len(person_phrase.text):
		person_phrase.visible_characters += 1
		
		timer.set_wait_time(text_speed)
		timer.start()
		yield(timer, "timeout")
		
	finished = true
	phrase_index += 1
