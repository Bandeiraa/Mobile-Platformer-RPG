extends Control

onready var life = get_node("HeartLabel")

func _ready():
	life.text = "" #Default value
