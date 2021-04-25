extends Area2D

signal animate
signal hit_animation

onready var animated_sprite = get_node("AnimatedSprite")

var direction = 1

func set_arrow_direction(dir):
	direction = dir
	
	
func _physics_process(_delta):
	emit_signal("animate", direction)
	translate(Vector2(3 * direction, 0))


func _on_screen_exited():
	queue_free()


func _on_Arrow_body_entered(_body):
	set_physics_process(false)
	emit_signal("hit_animation")
