extends Area2D

export var damage = 1

func _ready():
	randomize()
	var random_damage_value = randi() % 3 + 1
	damage = random_damage_value
