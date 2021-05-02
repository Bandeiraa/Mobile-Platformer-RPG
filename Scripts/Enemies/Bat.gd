extends KinematicBody2D

const DEATH_EFFECT = preload("res://Scenes/Enemies/DeathEffect.tscn") 
const DAMAGE_POPUP = preload("res://Scenes/Enviroments/DamagePopup.tscn")

onready var detection_zone = get_node("DetectionZone")
onready var stats = get_node("Stats")
onready var hurtbox = get_node("Hurtbox")
onready var timer = get_node("Timer")
onready var wander_controller = get_node("WanderController")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

signal direction
signal bat_count

enum {
	IDLE,
	WANDER,
	CHASE
}

var amount = 0
var state = IDLE
var monster_type = "Morcego"

var gravity = 500
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
	
func _ready():
	randomize()
	state = new_state([IDLE, WANDER])
	
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek()
			
			if wander_controller.get_time_left() == 0:
				update_wander()
			
		WANDER:
			seek()
			if wander_controller.get_time_left() == 0:
				update_wander()
				
			accelerate_towards(wander_controller.target_position, delta)

			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
				
		CHASE:
			var player = detection_zone.player
			if player != null:
				accelerate_towards(player.global_position, delta)
				
			else:
				state = IDLE
				
	emit_signal("direction", velocity.x)
	velocity = move_and_slide(velocity)
	
	
func update_wander():
	state = new_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))
	
	
func accelerate_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	
func seek():
	if detection_zone.can_track_player():
		state = CHASE
	
	
func new_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
	
func _on_Hurtbox_area_entered(area):
	var text = DAMAGE_POPUP.instance()
	text.amount = area.damage
	add_child(text)
	stats.health -= area.damage
	knockback.x = area.direction * 80
	hurtbox.create_hit_effect()


func _kill():
	timer.start()
	
	
func verify_amount():
	Singleton.stored_data.bat_amount += 1
	Singleton.save()
	Singleton.loadData()
	amount = Singleton.stored_data.bat_amount
	return amount
	
	
func _on_Timer_timeout():
	emit_signal("bat_count", monster_type, verify_amount())
	queue_free()
	var enemyDeathEffect = DEATH_EFFECT.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
