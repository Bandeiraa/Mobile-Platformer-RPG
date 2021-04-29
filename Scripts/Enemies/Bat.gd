extends KinematicBody2D

const DEATH_EFFECT = preload("res://Scenes/Enemies/DeathEffect.tscn") 
const DAMAGE_POPUP = preload("res://Scenes/Enviroments/DamagePopup.tscn")

onready var detection_zone = get_node("DetectionZone")
onready var stats = get_node("Stats")
onready var hurtbox = get_node("Hurtbox")
onready var timer = get_node("Timer")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

signal direction

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

var gravity = 500
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	#knockback.y += gravity * delta #If I want the bat to have gravity
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek()
			
		WANDER:
			pass
			
		CHASE:
			var player = detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
				
	emit_signal("direction", velocity.x)
	velocity = move_and_slide(velocity)
	
	
func seek():
	if detection_zone.can_track_player():
		state = CHASE
	
	
func _on_Hurtbox_area_entered(area):
	var text = DAMAGE_POPUP.instance()
	text.amount = area.damage
	add_child(text)
	stats.health -= area.damage
	knockback.x = area.direction * 80
	hurtbox.create_hit_effect()


func _kill():
	timer.start()
	
	
func _on_Timer_timeout():
	queue_free()
	var enemyDeathEffect = DEATH_EFFECT.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
