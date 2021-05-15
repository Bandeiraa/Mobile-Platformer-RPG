extends KinematicBody2D

#Icon spawner and npc picture to dialog box
onready var quest_icon = get_node("QuestIconSpawner")
const npc_photo = preload("res://Sprites/Faceset/AldeaMirtha.png")

#Quest info -> Monster type, Amount to kill, Npc name, Quest title
var quest_info = ["Morcego", 3, "Aldeã Mirtha", "Morcegos Eliminados: "]

#Start, end and after-quest dialogs
var start_quest_dialogue = ["Olá aventureiro, gostaria de realizar uma pequena missão? Você será bem recompensado!", 
							"Recentemente monstros começaram a atacar a nossa vila, comendo a nossa plantação e fazendo barulhos assustadores à noite", 
							"Estamos suspeitando de que eles estejam criando um ninho mais para o Leste da vila", 
							"Você poderia derrotar 3 morcegos, para tentar inibir os monstros da nossa vila?"]
							
var end_quest_dialogue = ["Vejo que você eliminou alguns morcegos, aqui está a sua recompensa!"]
var normal_dialogue = ["Obrigado por ter ajudado a conter a proliferação dos morcegos, aventureiro!"]

#Player reference to interact and quest state
var player_ref = null
var quest_state = "start_quest"

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and player_ref != null:
		match quest_state:
			"start_quest":
				on_interact(start_quest_dialogue, "start_quest")
				quest_state = "" #If I want to do an "in progress" dialog
			
			"end_quest":
				on_interact(end_quest_dialogue, "end_quest")
				quest_state = "normal_dialogue"
			
			"normal_dialogue":
				on_interact(normal_dialogue, "normal_dialogue")
			
			
func on_interact(dialogue, quest_status):
	get_tree().call_group("HUD", "call_dialogue", quest_info, dialogue, quest_status, npc_photo)
	player_ref = null
	quest_icon.hide()
	dialogue = null
	get_tree().paused = true
	
	
func _on_DetectionZone_body_entered(body):
	player_ref = body
	if quest_state != "normal_dialogue" or quest_state != "":
		quest_icon.show()
		
		
func _on_DetectionZone_body_exited(_body):
	player_ref = null
	quest_icon.hide()
	
	
func can_finish_quest():
	quest_state = "end_quest"
	quest_icon.show()
