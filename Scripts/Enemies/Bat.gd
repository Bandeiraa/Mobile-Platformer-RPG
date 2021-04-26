extends Area2D

onready var timer = get_node("Timer")

signal direction

var direction = -1

func _ready():
	timer.start()
	
	
func _physics_process(_delta):
	translate(Vector2(.8 * direction, 0))

func _on_Timer_timeout():
	direction *= -1
	emit_signal("direction", direction)
	timer.start()
