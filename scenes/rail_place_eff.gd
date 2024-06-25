extends GPUParticles2D


# Called when the node enters the scene tree for the first time.

var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if (time > 2):
		queue_free()
