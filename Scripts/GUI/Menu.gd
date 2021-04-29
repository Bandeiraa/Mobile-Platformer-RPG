extends Control

var _change_scene

onready var menu = get_node("CentralIcon")
onready var newGame_button = get_node("CentralIcon/NewGameButton")
onready var continueGame_button = get_node("CentralIcon/LoadGameButton")
onready var exitGame_button = get_node("CentralIcon/ExitGameButton")
onready var screen_animation = get_node("Animation")
onready var skin_container = get_node("SkinSelectorContainer")

func _ready():
	newGame_button.set_focus_mode(Control.FOCUS_NONE)
	continueGame_button.set_focus_mode(Control.FOCUS_NONE)
	exitGame_button.set_focus_mode(Control.FOCUS_NONE)
	
	
func _on_NewGameButton_pressed():
	menu.hide()
	skin_container.show()
	
	
func _on_ExitGameButton_pressed():
	get_tree().quit()


func _on_Default_skin_selected():
	screen_animation.play("FadeScreen")
	Singleton.stored_data.skin = "_00"
	Singleton.save()
	yield(get_tree().create_timer(1), "timeout")
	_change_scene = get_tree().change_scene("res://Scenes/Levels/TemplateLevel.tscn")


func _on_Red_skin_selected():
	screen_animation.play("FadeScreen")
	Singleton.stored_data.skin = "_01"
	Singleton.save()
	yield(get_tree().create_timer(1), "timeout")
	_change_scene = get_tree().change_scene("res://Scenes/Levels/TemplateLevel.tscn")
