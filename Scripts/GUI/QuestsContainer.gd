extends Control

onready var quest_container = get_node("VBoxContainer/QuestContainer")
onready var button = get_node("VBoxContainer/QuestTexture")

func _ready():
	button.set_focus_mode(Control.FOCUS_NONE) 
	
	
func _on_QuestTexture_pressed():
	quest_container.visible = !quest_container.is_visible()
	
	
func display_quest_status(quest_description, minimum_amount, total_amount, monster_type):
	self.show()
	var label = Label.new()
	label.autowrap = true
	label.align = label.ALIGN_CENTER
	label.valign = label.VALIGN_CENTER
	label.text = "* " + quest_description + " " + minimum_amount + "/" + str(total_amount)
	label.name = monster_type
	quest_container.add_child(label)
	
	
func update_quest_status(monster_type):
	for quest in quest_container.get_children():
		if monster_type in quest.name:
			var get_values = quest.text.split(":", false)[1]
			var current_amount = int(get_values.split("/")[0])
			var total_amount = quest.text.split("/")[1]
			var quest_text = quest.text.split(":")[0]
			current_amount += 1
			quest.text = quest_text + ": " + str(current_amount) + "/" + total_amount

			if current_amount == int(total_amount):
				get_tree().call_group("Npc", "quest_finished", monster_type, total_amount)
				
				
func kill_current_quest(monster_type, quantity):
	for quest in quest_container.get_children():
		var total_amount = quest.text.split("/")[1]
		if int(quantity) == int(total_amount) and monster_type in quest.name:
			quest.queue_free()
