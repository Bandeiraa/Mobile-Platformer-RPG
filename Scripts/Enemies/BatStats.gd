extends "res://Scripts/Enemies/Stats.gd"

func _ready():
	randomize()
	var random_health_value = randi() % 5 + 1
	health = random_health_value
