extends TileMap

const RAIL_COORD = Vector2i(10, 5)
const MARKER_COORD = Vector2i(0, 5)

var previous_coord = Vector2i(0,0)
# translate global mouse coordinates to tilemap coordinate
var global_mouse_coord = Vector2i(0,0)
var tilemap_mouse_coord = Vector2i(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# translate global mouse coordinates to tilemap coordinate
	global_mouse_coord = get_global_mouse_position()
	tilemap_mouse_coord = local_to_map(global_mouse_coord)
	show_marker()
	
# temporary marker of which tile the player is hovering over
func show_marker():
	if (previous_coord != tilemap_mouse_coord):
		set_cell(2, tilemap_mouse_coord, 0, MARKER_COORD, 0)
		erase_cell(2, previous_coord)
		previous_coord = tilemap_mouse_coord
	
func _input(event):
	if (event.is_action_pressed("place")):
		place()

# Place the rail on the tilemap
func place():
	set_cell(1, tilemap_mouse_coord, 0, RAIL_COORD, 0)
	pass
