extends KinematicBody2D

signal animate

const FLOOR = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const SLOPE_THRESHOLD = deg2rad(45)

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var speed = 100
var jump_speed = -250
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func move():
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction.x * speed
	
	
func jump():
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		snap_vector = Vector2.ZERO
		velocity.y = jump_speed
		
		
func _physics_process(delta):
	move()
	emit_signal("animate", velocity, is_on_floor())
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR, true, 4, SLOPE_THRESHOLD).y
	jump()
