extends KinematicBody2D

const FLOOR = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const SLOPE_THRESHOLD = deg2rad(45)

onready var sprite = get_node("Sprite")

var speed = 200
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

var snap_vector = SNAP_DIRECTION * SNAP_LENGTH

var gravity = 1000

func move():
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction.x * speed
		
		
func animate(input_movement):
	get_orientation(input_movement)
	if input_movement.x != 0:
		sprite.play("Run")
	else:
		sprite.play("Idle")
		
	
func get_orientation(input):
	if input.x > 0:
		sprite.flip_h = false
	elif input.x < 0:
		sprite.flip_h = true
		
		
func _physics_process(delta):
	move()
	animate(velocity)
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR, true, 4, SLOPE_THRESHOLD).y
