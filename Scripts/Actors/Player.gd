extends KinematicBody2D

onready var sprite = get_node("Sprite")

var speed = 200
var velocity = Vector2.ZERO
var gravity = 100

func move():
	velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x += speed
		
		
func animate(input_movement):
	get_orientation(input_movement)
	if input_movement.x != 0:
		sprite.play("Run")
	else:
		sprite.play("Idle")
		
	
func get_orientation(direction):
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
		
		
func _physics_process(delta):
	move()
	animate(velocity)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
