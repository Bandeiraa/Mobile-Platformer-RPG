extends KinematicBody2D

signal animate
signal attack 
signal die
signal disconnect_camera
signal send_status
#signal respawn

const DEATH_EFFECT = preload("res://Scenes/Enemies/DeathEffect.tscn")
const DAMAGE_POPUP = preload("res://Scenes/Enviroments/DamagePopup.tscn")
const PARTICLES = preload("res://Scenes/Actors/FeetParticles.tscn")

onready var camera = get_node("Camera")
onready var player_stats = get_node("Stats")
onready var arrow_spawner = get_node("ArrowSpawner")
onready var raycast = get_node("RayCast2D")
onready var hurtbox = get_node("Hurtbox")

const FLOOR = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const SLOPE_THRESHOLD = deg2rad(45)

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var jumping = false
var can_receive_input = true
var speed = 100
var jump_speed = -200
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func _ready():
	emit_signal("send_status", player_stats.attack, player_stats.max_health)
	update_health(player_stats.health)
	
	
func move():
	direction.x = 0
	if Input.is_action_pressed("ui_right") and can_receive_input and not Input.is_action_pressed("ui_left"):
		direction.x = 1
	elif not Input.is_action_pressed("ui_right") and can_receive_input and Input.is_action_pressed("ui_left"):
		direction.x = -1 
		
	arrow_spawner.arrow_direction()
	velocity.x = direction.x * speed
	
	
func jump():
	if is_on_floor() and not jumping and Input.is_action_just_pressed("ui_select"):
		snap_vector = Vector2.ZERO
		velocity.y = jump_speed
		jumping = true
		
	elif jumping:
		if is_on_floor(): #Hits when reach the floor after a jump
			camera.add_trauma(0.20)
			var feet_particles = PARTICLES.instance()
			get_tree().root.call_deferred("add_child", feet_particles)
			feet_particles.emit_particles()
			feet_particles.position = self.global_position + Vector2(0, 12)
			jumping = false
		
		
func attack():
	if Input.is_action_just_pressed("Attack"):
		emit_signal("attack")
		velocity.x = 0
		can_receive_input = false
		
		
func _turn_physics_on():
	set_physics_process(true)
	can_receive_input = true
	
	
func turn_physics_off():
	set_physics_process(false)
	
	
func is_colliding():
	if raycast.is_colliding():
		if raycast.get_collider().is_in_group("Interactables"):
			return true
			
			
func drop_platform():
	if is_colliding():
		if Input.is_action_just_pressed("ui_down"):
			get_tree().call_group("Interactables", "disable_collision")
		
		
func _physics_process(delta):
	drop_platform()
	move()
	attack()
	emit_signal("animate", velocity, is_on_floor())
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR, true, 4, SLOPE_THRESHOLD).y
	jump()
	
	
func update_health(value):
	get_tree().call_group("Health_GUI", "update_hp", value)
	
	
func _on_Hurtbox_area_entered(area):
	var text = DAMAGE_POPUP.instance()
	text.amount = area.damage
	add_child(text)
	player_stats.health -= area.damage
	camera.add_trauma(0.3)
	update_health(player_stats.health)
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	
	
func _camera_shake():
	camera.add_trauma(0.15)


func kill():
	emit_signal("disconnect_camera")
	emit_signal("die")
	get_tree().call_group("Interactables", "enable_collision")
	queue_free()
	var enemyDeathEffect = DEATH_EFFECT.instance()
	get_tree().get_root().call_deferred("add_child", enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	#emit_signal("respawn")
	
	
func update_status(health_bonus, attack_bonus):
	player_stats.attack += attack_bonus
	player_stats.max_health += health_bonus
	player_stats.health += health_bonus
	get_node("ArrowSpawner").arrow_damage = player_stats.attack
