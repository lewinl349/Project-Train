extends Area2D

const SPEED = 20;

func _process(delta):
	position.x += SPEED * delta
