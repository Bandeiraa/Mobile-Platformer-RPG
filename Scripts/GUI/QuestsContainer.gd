extends Control

onready var quest_container = get_node("VBoxContainer/QuestContainer")

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
