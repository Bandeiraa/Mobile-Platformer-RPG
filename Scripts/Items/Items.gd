extends Node

var items_list = []

func get_random_value():
	randomize()
	var random_value = randi () % 100 + 1
	return random_value
