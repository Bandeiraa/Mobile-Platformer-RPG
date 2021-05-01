extends Control

onready var quest_container = get_node("VBoxContainer/QuestContainer")

func _on_QuestTexture_pressed():
	quest_container.visible = !quest_container.is_visible()
	
	
func display_quest_status(quest_description):
	self.show()
	var label = Label.new()
	label.autowrap = true
	label.align = label.ALIGN_CENTER
	label.valign = label.VALIGN_CENTER
	label.text = "* " + quest_description
	quest_container.add_child(label)
