extends Area2D

var SPEED = 20;

@onready var tilemap = get_node("../TileMap2")

func _ready():
	print(tilemap)

func _process(delta):
	SPEED += 2 * delta
	position.x += SPEED * delta
	var curr_tile = tilemap.get_cell_atlas_coords(1, tilemap.local_to_map(global_position))
	pass

func in_middle_of_rail() -> bool:
	return false
	var left_bound = tilemap.local_to_map(Vector2(global_position.x-8, global_position.y))
	var right_bound = tilemap.local_to_map(Vector2(global_position.x+9, global_position.y))
	if(tilemap.get_cell_source_id(1, left_bound) == -1 and tilemap.get_cell_source_id(1, right_bound) == -1):
		SPEED = 0;
		return true
	return false
