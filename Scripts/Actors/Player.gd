extends KinematicBody2D

signal animate
signal attack 

onready var arrow_spawner = get_node("ArrowSpawner")

const FLOOR = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const SLOPE_THRESHOLD = deg2rad(45)

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var speed = 100
var jump_speed = -200
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func move():
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	arrow_spawner.arrow_direction()
	velocity.x = direction.x * speed
	
	
func jump():
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		snap_vector = Vector2.ZERO
		velocity.y = jump_speed
		
		
func attack():
	if Input.is_action_just_pressed("Attack"):
		emit_signal("attack")
		set_physics_process(false)
		
		
func _turn_physics():
	set_physics_process(true)
	
	
func _physics_process(delta):
	move()
	attack()
	emit_signal("animate", velocity, is_on_floor())
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR, true, 4, SLOPE_THRESHOLD).y
	jump()
