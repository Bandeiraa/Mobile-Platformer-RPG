extends Node

export var max_health = 1
onready var health = max_health setget set_health 

signal kill

func set_health(value):
	health = value
	if health <= 0:
		yield(get_tree().create_timer(0.2), "timeout")
		emit_signal("kill")
