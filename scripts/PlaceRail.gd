extends TileMap
const BOTTOM = 0
const STATION = 1
const RAILS = 2
const OBSTACLES = 3
const UI = 4

var speed = 50

const RAIL_COORD = Vector2i(0, 0)
const MARKER_COORD = Vector2i(2,2)
const GROUND_COORD = Vector2i(0,9)
const ROCK_COORD = Vector2i(0,2)
const HOLE_COORD = Vector2i(1,11)



@onready var tilemap = get_node("/root/World/TileMap")
@onready var train = get_node("/root/World/Train")
var previous_coord = Vector2i(0,0)
# translate global mouse coordinates to tilemap coordinate
var global_mouse_coord = Vector2i(0,0)
var tilemap_mouse_coord = Vector2i(0,0)

# rail direction based on input
var rail_direction = 0;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = train.SPEED
	var layer_index := 0
	tile_set.set_occlusion_layer_light_mask(layer_index, tile_set.get_occlusion_layer_light_mask(layer_index))	
	
	
	position.x -= speed*delta
	# translate global mouse coordinates to tilemap coordinate
	global_mouse_coord = get_global_mouse_position()
	var offset_mouse_coord = Vector2(global_mouse_coord.x - position.x, global_mouse_coord.y)
	tilemap_mouse_coord = local_to_map(offset_mouse_coord)
	if(global_mouse_coord.y > 24*4 and !((BetterTerrain.get_cell(self, RAILS, tilemap_mouse_coord ) == 3) or
		tilemap.get_cell_atlas_coords(OBSTACLES, tilemap_mouse_coord) == ROCK_COORD or
		(BetterTerrain.get_cell(self, BOTTOM, tilemap_mouse_coord ) == 2))):
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
	
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and global_mouse_coord.y > 24*4):
		place()

	#if (event.is_action_pressed("place")):
		#place()

# Place the rail on the tilemap
func place():
	if((BetterTerrain.get_cell(self, RAILS, tilemap_mouse_coord ) == 3) or
		tilemap.get_cell_atlas_coords(OBSTACLES, tilemap_mouse_coord) == ROCK_COORD or
		(BetterTerrain.get_cell(self, BOTTOM, tilemap_mouse_coord ) == 2)):
			return
	
		
	# for current tilemap
	BetterTerrain.set_cell(self, RAILS, tilemap_mouse_coord, 3)
	BetterTerrain.update_terrain_area(self, RAILS, Rect2i(tilemap_mouse_coord.x, tilemap_mouse_coord.y, tilemap_mouse_coord.x, tilemap_mouse_coord.y) )
	BetterTerrain.set_cell(self, BOTTOM, tilemap_mouse_coord, 0)
	BetterTerrain.update_terrain_area(self, BOTTOM, Rect2i(tilemap_mouse_coord.x, tilemap_mouse_coord.y, tilemap_mouse_coord.x, tilemap_mouse_coord.y) )

	# for other tilemap
	if (tilemap_mouse_coord.x >=36):
		var offest_tilemap_mouse_coord = Vector2(tilemap_mouse_coord.x-36, tilemap_mouse_coord.y)
		BetterTerrain.set_cell(self, RAILS, offest_tilemap_mouse_coord, 3)
		BetterTerrain.update_terrain_area(self, RAILS, Rect2i(offest_tilemap_mouse_coord.x, offest_tilemap_mouse_coord.y, offest_tilemap_mouse_coord.x, offest_tilemap_mouse_coord.y) )
		BetterTerrain.set_cell(self, BOTTOM, offest_tilemap_mouse_coord, 0)
		BetterTerrain.update_terrain_area(self, BOTTOM, Rect2i(offest_tilemap_mouse_coord.x, offest_tilemap_mouse_coord.y, offest_tilemap_mouse_coord.x, offest_tilemap_mouse_coord.y) )
	
