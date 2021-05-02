extends Control

signal show_quest
signal kill_quest

onready var person_name = get_node("DialogueBox/Name")
onready var person_image = get_node("DialogueBox/FaceBox/ImageRect")
onready var person_phrase = get_node("DialogueBox/Text")
onready var timer = get_node("Timer")
onready var button = get_node("TextureButton")

export var text_speed = 0.05

var status_type
var dialogue_path = ""
var dialogue
var description
var finished = false 
var phrase_number = 0

func get_dialogue(json, status):
	dialogue_path = json
	dialogue = get_json_as_text()
	status_type = status
	next_phrase()
	
	
func _process(_delta):
	button.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phrase()
			
		else:
			person_phrase.visible_characters = len(person_phrase.text)
			
			
func get_json_as_text():
	var file = File.new()
	assert(file.file_exists(dialogue_path), "File path does not exist")
	
	file.open(dialogue_path, File.READ)
	var json = file.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
		
func next_phrase():
	if status_type == "initializing":
		if phrase_number >= len(dialogue) - 1:
			queue_free()
			get_tree().paused = false
			var quest_description = dialogue[len(dialogue) - 1]["Quest_Description"]
			var amount = dialogue[len(dialogue) - 1]["Enemies_Amount"]
			var type = dialogue[len(dialogue) - 1]["Monster_Type"]
			emit_signal("show_quest", quest_description, amount, type)
			return
			
	else:
		if phrase_number >= len(dialogue):
			queue_free()
			get_tree().paused = false
			var type = dialogue[len(dialogue) - 1]["Monster_Type"]
			var amount = dialogue[len(dialogue) - 1]["Amount"]
			emit_signal("kill_quest", type, amount)
			return
		
	finished = false
	person_name.bbcode_text = dialogue[phrase_number]["Name"]
	person_phrase.bbcode_text = dialogue[phrase_number]["Text"]
		
	person_phrase.visible_characters = 0
	
	var file = File.new()
	var base_dialogs_file_path = "Sprites/Faceset/"
	var image = base_dialogs_file_path + dialogue[phrase_number]["Name"] + ".png"
	person_image.texture = load(image) if file.file_exists(image) else person_image.set_texture(null)
	
	while person_phrase.visible_characters < len(person_phrase.text):
		person_phrase.visible_characters += 1
		
		timer.set_wait_time(text_speed)
		timer.start()
		yield(timer, "timeout")
		
	finished = true
	phrase_number += 1
	return
