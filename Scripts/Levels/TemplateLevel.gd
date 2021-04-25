extends Node

onready var player = load("res://Scenes/Actors/Player.tscn")
onready var player_spawn_position = get_node("PlayerSpawnPosition")

func _ready():
	spawn_player()
	
	
func spawn_player():
	var instanced_player = player.instance()
	player_spawn_position.call_deferred("add_child", instanced_player)
	instanced_player.connect("respawn", self, "spawn_player")
