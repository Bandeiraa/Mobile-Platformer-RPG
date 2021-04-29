extends CanvasLayer

const dialogue_system = preload("res://Scenes/GUI/DialogueContainer.tscn")

func call_dialogue(dialogue):
	var dialogue_container = dialogue_system.instance()
	self.add_child(dialogue_container)
	dialogue_container.get_dialogue(dialogue)
	
	
func hide():
	get_node("LifeContainer").hide()
	get_node("ManaContainer").hide()
	
	
func show():
	get_node("LifeContainer").show()
	get_node("ManaContainer").show()
