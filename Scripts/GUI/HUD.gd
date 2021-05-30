extends CanvasLayer

const dialogue_system = preload("res://Scenes/GUI/DialogueContainer.tscn")

signal spawn

onready var quest_container = get_node("QuestsContainer")
onready var animation = get_node("Animation")
onready var inventory_container = get_node("Inventory")
	
func _process(_delta):
	if Input.is_action_just_pressed("Inventory"):
		inventory()
		
		
func call_dialogue(quest_info, dialogue, status_type, npc_photo):
	var dialogue_container = dialogue_system.instance()
	self.add_child(dialogue_container)
	dialogue_container.get_dialogue(quest_info, dialogue, status_type, npc_photo)
	dialogue_container.connect("show_quest", quest_container, "display_quest_status")
	dialogue_container.connect("kill_quest", quest_container, "kill_current_quest")
	
	
func play_animation():
	animation.play("Hide")
	
	
func died_screen_animation():
	animation.play_backwards("DiedScreen")
	
	
func spawn():
	emit_signal("spawn")


func inventory():
	inventory_container.visible = !inventory_container.visible
