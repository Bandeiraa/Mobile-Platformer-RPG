extends CanvasLayer

const dialogue_system = preload("res://Scenes/GUI/DialogueContainer.tscn")

signal spawn

onready var animation = get_node("Animation")

func call_dialogue(dialogue):
	var dialogue_container = dialogue_system.instance()
	self.add_child(dialogue_container)
	dialogue_container.get_dialogue(dialogue)
	
	
func play_animation():
	animation.play("Hide")
	
	
func died_screen_animation():
	animation.play_backwards("DiedScreen")
	
	
func spawn():
	emit_signal("spawn")
