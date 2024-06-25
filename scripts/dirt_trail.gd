extends ColorRect

@onready var train = get_parent()

var max_dist = 300

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size.x += train.SPEED * delta
	if(size.x >= max_dist):
		queue_free()

func update_duration():
	max_dist = 150 + size.x
