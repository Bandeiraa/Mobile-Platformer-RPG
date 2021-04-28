extends Control

onready var person_name = get_node("DialogueBox/Name")
onready var person_image = get_node("DialogueBox/FaceBox/ImageRect")
onready var person_phrase = get_node("DialogueBox/Text")
onready var timer = get_node("Timer")
onready var button = get_node("TextureButton")

export var text_speed = 0.05

var dialog_path = ""
var dialog
var finished = false 
var phrase_number = 0

func get_dialogue(dialogue):
	dialog_path = dialogue
	dialog = get_dialog()
	next_phrase()
	
	
func _process(_delta):
	button.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phrase()
			
		else:
			person_phrase.visible_characters = len(person_phrase.text)
			
			
func get_dialog():
	var file = File.new()
	assert(file.file_exists(dialog_path), "File path does not exist")
	
	file.open(dialog_path, File.READ)
	var json = file.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
		
func next_phrase():
	if phrase_number >= len(dialog):
		queue_free()
		return
		
	finished = false
	person_name.bbcode_text = dialog[phrase_number]["Name"]
	person_phrase.bbcode_text = dialog[phrase_number]["Text"]
		
	person_phrase.visible_characters = 0
	
	var file = File.new()
	var base_dialogs_file_path = "res://Sprites/Faceset/"
	var image = base_dialogs_file_path + dialog[phrase_number]["Name"] + ".png"
	person_image.texture = load(image) if file.file_exists(image) else person_image.set_texture(null)
	
	while person_phrase.visible_characters < len(person_phrase.text):
		person_phrase.visible_characters += 1
		
		timer.set_wait_time(text_speed)
		timer.start()
		yield(timer, "timeout")
		
	finished = true
	phrase_number += 1
	return
