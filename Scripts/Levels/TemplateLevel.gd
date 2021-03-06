extends Node

onready var player = load("res://Scenes/Actors/Player.tscn")
onready var player_spawn_position = get_node("PlayerSpawnPosition")
onready var lady_villager = get_node("Npcs/VillagerLady")
onready var HUD = get_node("HUD")
onready var inventory_ref = HUD.get_node("Inventory/InventoryContainer/InventoryTexture/InventorySlotContainer")
onready var equipment_inventory_ref = HUD.get_node("Inventory/EquipmentsInventoryContainer/EquipmentsInventoryTexture/StatusContainer")
onready var quest_container = HUD.get_node("QuestsContainer")

onready var player_camera = get_node("PlayerSpawnPosition/Camera")

onready var enemies = get_node("Enemies")
onready var npcs = get_node("Npcs")

var instanced_player
var dialogue_flag = false
var dialogue = ""
var dialogue_requirement = ""

func _ready():
	HUD.connect("spawn", self, "spawn_elements")
	for enemy in enemies.get_node("Bats").get_children():
		enemy.connect("bat_count", quest_container, "update_quest_status")
		
	
func spawn_elements():
	spawn_player()
	npcs.show()
	enemies.show()
	
	
func spawn_player():
	instanced_player = player.instance()
	player_spawn_position.call_deferred("add_child", instanced_player)
	instanced_player.connect("die", HUD, "died_screen_animation")
	instanced_player.connect("disconnect_camera", self, "change_camera")
	instanced_player.connect("send_status", equipment_inventory_ref, "set_status_text")
	equipment_inventory_ref.connect("send_bonus_status", instanced_player, "update_status")
	instanced_player.get_node("LootRange").connect("send_dropped_item", inventory_ref, "get_item")
	
	
func change_camera():
	player_camera.position = instanced_player.position
	player_camera.limit_left = -550
	player_camera.current = true
