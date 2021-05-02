extends Control

onready var quest_container = get_node("VBoxContainer/QuestContainer")
onready var button = get_node("VBoxContainer/QuestTexture")

func _ready():
	button.set_focus_mode(Control.FOCUS_NONE) 
	
	
func _on_QuestTexture_pressed():
	quest_container.visible = !quest_container.is_visible()
	
	
func display_quest_status(quest_description, total_amount, monster_type):
	self.show()
	var label = Label.new()
	label.autowrap = true
	label.align = label.ALIGN_CENTER
	label.valign = label.VALIGN_CENTER
	label.text = "* " + quest_description + "0/" + str(total_amount)
	label.name = monster_type
	quest_container.add_child(label)
	
	
func update_quest_status(monster_type, quantity):
	for quest in quest_container.get_children():
		if quest.name in monster_type:
			quest.text = quest.text.replace(str(quantity - 1) +  "/", str(quantity) + "/" )
			var total_amount = quest.text.substr(quest.text.find("/") + 1)
			if quantity == int(total_amount):
				get_tree().call_group("Npc", "quest_finished", monster_type)
				
				
func kill_current_quest(monster_type):
	for quest in quest_container.get_children():
		if quest.name == monster_type:
			quest.queue_free()
