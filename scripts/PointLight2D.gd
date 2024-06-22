extends PointLight2D

@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _on_timer_timeout():
	var rand_amt = (randf())
	energy = rand_amt * 0.5 + 0.5
	timer.start(rand_amt/3)

