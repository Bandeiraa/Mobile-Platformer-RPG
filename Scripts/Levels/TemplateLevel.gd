extends Node

onready var player = load("res://Scenes/Actors/Player.tscn")
onready var player_spawn_position = get_node("PlayerSpawnPosition")
onready var lady_villager = get_node("Npcs/VillagerLady")
onready var HUD = get_node("HUD")

onready var player_camera = get_node("PlayerSpawnPosition/Camera")

onready var enemies = get_node("Enemies")
onready var npcs = get_node("Npcs")

var instanced_player
var dialogue_flag = false
var dialogue = ""

func _ready():
	lady_villager.connect("can_interact", self, "interact")
	lady_villager.connect("cannot_interact", self, "cannot_interact")
	HUD.connect("spawn", self, "spawn_elements")
	
	
func spawn_elements():
	spawn_player()
	npcs.show()
	enemies.show()
	
	
func spawn_player():
	instanced_player = player.instance()
	player_spawn_position.call_deferred("add_child", instanced_player)
	#instanced_player.connect("respawn", self, "spawn_player")
	instanced_player.connect("die", HUD, "died_screen_animation")
	instanced_player.connect("disconnect_camera", self, "change_camera")
	
	
func _process(_delta):
	if Input.is_action_just_pressed("Interact") and dialogue_flag:
		get_tree().call_group("HUD", "call_dialogue", dialogue)
		dialogue_flag = false
		lady_villager.kill_dialog_path()
		get_tree().paused = true
		
		
func interact(current_dialogue):
	dialogue = current_dialogue
	dialogue_flag = true
	
	
func cannot_interact():
	dialogue_flag = false
	
	
func change_camera():
	player_camera.position = instanced_player.position
	player_camera.limit_left = -550
	player_camera.current = true
