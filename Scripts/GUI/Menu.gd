extends Control

var _change_scene

onready var newGame_button = get_node("CentralIcon/NewGameButton")
onready var continueGame_button = get_node("CentralIcon/LoadGameButton")
onready var exitGame_button = get_node("CentralIcon/ExitGameButton")
onready var screen_animation = get_node("Animation")

func _ready():
	newGame_button.set_focus_mode(Control.FOCUS_NONE)
	continueGame_button.set_focus_mode(Control.FOCUS_NONE)
	exitGame_button.set_focus_mode(Control.FOCUS_NONE)
	
	
func _on_NewGameButton_pressed():
	screen_animation.play("FadeScreen")
	yield(get_tree().create_timer(1), "timeout")
	_change_scene = get_tree().change_scene("res://Scenes/Levels/TemplateLevel.tscn")
	
	
func _on_ExitGameButton_pressed():
	get_tree().quit()
