extends TileMap
const BOTTOM = 0
const STATION = 1
const RAILS = 2
const OBSTACLES = 3
const UI = 4



const RAIL_COORD = Vector2i(0, 0)
const MARKER_COORD = Vector2i(2,2)
const GROUND_COORD = Vector2i(0,9)

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
	if(global_mouse_coord.y > 24*4):
		show_marker()
	else:
		erase_cell(UI, previous_coord)
		
	# translate if on certrain track
	
# temporary marker of which tile the player is hovering over
func show_marker():
	if (previous_coord != tilemap_mouse_coord):
		set_cell(UI, tilemap_mouse_coord, 0, RAIL_COORD, 0)
		#set_cell(UI, tilemap_mouse_coord, 0, MARKER_COORD, 0)
		erase_cell(UI, previous_coord)
		previous_coord = tilemap_mouse_coord
	
func _input(event):
	
	if(Input.is_mouse_button_pressed(1) and global_mouse_coord.y > 24*4):
		place()
	
	
	#if (event.is_action_pressed("place")):
		#place()

# Place the rail on the tilemap
func place():
	BetterTerrain.set_cell(self, RAILS, tilemap_mouse_coord, 3)
	BetterTerrain.update_terrain_area(self, RAILS, Rect2i(tilemap_mouse_coord.x, tilemap_mouse_coord.y, tilemap_mouse_coord.x, tilemap_mouse_coord.y) )
	#var cells = get_surrounding_cells(tilemap_mouse_coord)

	BetterTerrain.set_cell(self, BOTTOM, tilemap_mouse_coord, 0)
	BetterTerrain.update_terrain_area(self, BOTTOM, Rect2i(tilemap_mouse_coord.x, tilemap_mouse_coord.y, tilemap_mouse_coord.x, tilemap_mouse_coord.y) )
	
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
