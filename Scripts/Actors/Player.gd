extends KinematicBody2D

signal animate
signal attack 
#signal respawn

const DEATH_EFFECT = preload("res://Scenes/Enemies/DeathEffect.tscn")
const DAMAGE_POPUP = preload("res://Scenes/Enviroments/DamagePopup.tscn")

onready var camera = get_node("Camera2D")
onready var player_stats = get_node("Stats")
onready var arrow_spawner = get_node("ArrowSpawner")
onready var raycast = get_node("RayCast2D")
onready var hurtbox = get_node("Hurtbox")
onready var timer = get_node("Timer")

const FLOOR = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const SLOPE_THRESHOLD = deg2rad(45)

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var can_receive_input = true
var can_shoot = false
var speed = 100
var jump_speed = -200
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func _ready():
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
	if is_on_floor():
		can_shoot = true
		if Input.is_action_just_pressed("ui_select"):
			snap_vector = Vector2.ZERO
			velocity.y = jump_speed
			#can_shoot = false
		
		
func attack():
	if Input.is_action_just_pressed("Attack") and can_shoot:
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
	
	
func _on_screen_exited():
	get_tree().call_group("Interactables", "enable_collision")
	kill()
	#emit_signal("respawn")
	
	
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
	
	
func kill():
	queue_free()
	var enemyDeathEffect = DEATH_EFFECT.instance()
	get_tree().get_root().call_deferred("add_child", enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	
func _camera_shake():
	camera.add_trauma(0.15)


func start_timer():
	timer.start()
