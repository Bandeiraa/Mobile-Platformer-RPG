extends "res://Scripts/Items/ItemTemplate.gd"

var gravity = 250
var velocity = Vector2()
var travel_to_player = false
var player_ref = null

var MAX_SPEED = 250
var ACCELERATION = 50

func _physics_process(delta):
	if not is_on_floor() and travel_to_player == false:
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)
		
	elif travel_to_player:
		accelerate_towards(player_ref.global_position, delta)
		velocity = move_and_slide(velocity, Vector2.UP)
		
		
func accelerate_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	
func _on_Item_area_entered(area):
	travel_to_player = true
	player_ref = area


func _on_Item_area_exited(_area):
	travel_to_player = false
	player_ref = null
