extends Area2D

var SPEED = 0;

@onready var tilemap = get_node("../TileMap2")

func _ready():
	print(tilemap)

func _process(delta):
	#SPEED += 2 * delta
	position.x += SPEED * delta
	#var curr_tile = tilemap.get_cell_atlas_coords(1, tilemap.local_to_map(global_position))

func _input(event):
	if(event.is_action_pressed("space")):
		position.y -= 24
