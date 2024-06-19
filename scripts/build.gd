extends TileMap

const RAIL_COORD = Vector2i(10, 5)
const MARKER_COORD = Vector2i(0, 5)
const RIGHT_DOWN_RAIL_COORD = Vector2i(11, 5);
const RIGHT_UP_RAIL_COORD = Vector2i(11, 7);
const DOWN_RIGHT_RAIL_COORD = Vector2i(9, 7);
const UP_RIGHT_RAIL_COORD = Vector2i(9, 5);
const UP_DOWN = Vector2i(9,6);
#const RAILS = [RAIL_COORD, RIGHT_DOWN_RAIL_COORD,RIGHT_UP_RAIL_COORD,DOWN_RIGHT_RAIL_COORD,UP_RIGHT_RAIL_COORD]
const RAILS = [RAIL_COORD, UP_DOWN, RIGHT_UP_RAIL_COORD, RIGHT_DOWN_RAIL_COORD, UP_RIGHT_RAIL_COORD, DOWN_RIGHT_RAIL_COORD]
#const dict = {
	#(-1,-1): 
#}

var previous_coord = Vector2i(0,0)
# translate global mouse coordinates to tilemap coordinate
var global_mouse_coord = Vector2i(0,0)
var tilemap_mouse_coord = Vector2i(0,0)

# rail direction based on input
var rail_direction = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# translate global mouse coordinates to tilemap coordinate
	global_mouse_coord = get_global_mouse_position()
	tilemap_mouse_coord = local_to_map(global_mouse_coord)
	if(global_mouse_coord.y > 0):
		show_marker()
		
	# translate if on certrain track
	
# temporary marker of which tile the player is hovering over
func show_marker():
	if (previous_coord != tilemap_mouse_coord):
		set_cell(2, tilemap_mouse_coord, 0, RAIL_COORD, 0)
		set_cell(3, tilemap_mouse_coord, 0, MARKER_COORD, 0)
		erase_cell(2, previous_coord)
		erase_cell(3, previous_coord)
		previous_coord = tilemap_mouse_coord
	
func _input(event):
	
	if(Input.is_mouse_button_pressed(1) and global_mouse_coord.y > 0):
		place()
	var forward = false
	var left = false;
	var right = false
	rail_direction = 0;
	
	if(Input.is_action_pressed("left") and Input.is_action_pressed("forward")):
		rail_direction = 2
	elif(Input.is_action_pressed("right") and Input.is_action_pressed("forward")):
		rail_direction = 3
	elif(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		rail_direction = 1
	if(Input.is_action_pressed("shift")):
		rail_direction +=2
	print(rail_direction)
		
	
	#if (event.is_action_pressed("place")):
		#place()

# Place the rail on the tilemap
func place():
	set_cell(1, tilemap_mouse_coord, 0, RAILS[rail_direction], 0)
	
	#var connections = []
	#var cells = get_surrounding_cells(tilemap_mouse_coord)
	#var right_cell = cells[0]
	#
		#
	#if connections.is_empty():
		#set_cell(1, tilemap_mouse_coord, 0, RAIL_COORD, 0)
	#else:
		#var tile = get_cell_atlas_coords(1, tilemap_mouse_coord)
		#var index = (connections.find(tile)+1) % len(connections)
		#if index == -1:
		#index = 0;
		#set_cell(1, tilemap_mouse_coord, 0, connections[index], 0)
