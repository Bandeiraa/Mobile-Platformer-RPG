extends Particles2D

var emit_key = false

func emit_particles():
	emitting = true
	emit_key = true
	
	
func _process(_delta):
	if self.is_emitting() == false and emit_key:
		queue_free()
