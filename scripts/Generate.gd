extends Node

# Class declarations
var rng = RandomNumberGenerator.new()
var tilemap

# Tilemap Layers
const BOTTOM = 0
const STATION = 1
const RAILS = 2
const OBSTACLES = 3
const UI = 4


# Coords of the tiles in tilemap
const GROUND_COORD = Vector2i(1,6)
const ROCK_COORD = Vector2i(0,2)
const RAIL_COORD = Vector2i(0,0)
const HOLE_COORD = Vector2i(1,11)

const STATION_BLOCKS = [Vector2i(1,3), Vector2i(1, 14), Vector2i(1,2)]

#backgrund and foreground starting points
const STATION_MAX = 3
const BACKGROUND_MAX = 9

# Size of background
const HEIGHT = 9
# Size of each playable chunk
const CHUNK_WIDTH = 18
const CHUNK_HEIGHT = 5
# Offset of the playable area
var y_offset = 4

var chunks_generated = 1
var partial_chunk = 0
var fire = null

var chunk_ground = []
var chunk_station = []
var chunk_rails = []
var chunk_obstacles = []

func _ready():
	fire = await preload("res://scenes/fire.tscn")
	tilemap = get_parent()
	generate_items(0)
	
	#for x in range(16, CHUNK_WIDTH * chunks_generated, CHUNK_WIDTH):
		## clear chunk
		#
		#generate_background(x)
		#generate_station_area(x)
		#generate_holes(x)
		#generate_obstacles(x)
		##generate_items(x)

	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#var fire = preload("res://scenes/fire.tscn").instantiate()
			#get_node("/root/World").add_child(fire)
			#fire.set_position(vector2())
		
var time = 0
func _process(delta):
	
	time += delta
	#
	#if( time >= 15):
		
	var off_pos = get_node("/root/World/Train").position.x - get_node("/root/World/Train").starting_offset
	if tilemap.position.x + (chunks_generated-1)*(CHUNK_WIDTH)*24 <= 0:
		if(partial_chunk>=CHUNK_WIDTH and chunks_generated > 2):
			chunks_generated = 1
			partial_chunk = 0
			tilemap.position.x = 0
		chunk_ground = []
		chunk_rails = []
		chunk_station = []
		chunk_obstacles = []
		for i in range(10):
			chunk_ground.append([])
			chunk_rails.append([])
			chunk_station.append([])
			chunk_obstacles.append([])
			for j in range(CHUNK_WIDTH):
				chunk_ground[i].append(-1)
				chunk_station[i].append(-1)
				chunk_rails[i].append(-1)
				chunk_obstacles[i].append(-1)
		var x = (chunks_generated)*CHUNK_WIDTH
		generate_background(x)
		generate_station_area(x)
		#print(chunk)
		generate_holes(x)
		generate_obstacles(x)
		#generate_items(x)
		chunks_generated+=1
		partial_chunk = 0

		print("asdasd")
	if (tilemap.position.x + (chunks_generated-2)*(CHUNK_WIDTH)*24 + 24 * partial_chunk <= 0):
		render_partial_chunk(chunk_ground, partial_chunk-1, BOTTOM, true)
		render_partial_chunk(chunk_station, partial_chunk-1, STATION, false)
		render_partial_chunk(chunk_rails, partial_chunk-1, RAILS, true)
		render_partial_chunk(chunk_obstacles, partial_chunk, OBSTACLES, false)
		delete_partial_chunk(partial_chunk-2 + (chunks_generated-2)*CHUNK_WIDTH)
		delete_partial_chunk(partial_chunk-2 + (chunks_generated)*CHUNK_WIDTH)
		if(chunks_generated>2):
			var temp = chunks_generated
			chunks_generated = 1
			render_partial_chunk(chunk_ground, partial_chunk-1, BOTTOM, true)
			render_partial_chunk(chunk_station, partial_chunk-1, STATION, false)
			render_partial_chunk(chunk_rails, partial_chunk-1, RAILS, true)
			render_partial_chunk(chunk_obstacles, partial_chunk, OBSTACLES, false)
			chunks_generated = temp
		partial_chunk += 1
		
func render_partial_chunk(chunk, partial_chunk, layer, connects):
	var x_tile = (chunks_generated-1) * CHUNK_WIDTH + partial_chunk
	
	if(connects):
		for y in range(1, 10):
			#if type_string(typeof(chunk[y][partial_chunk])) == 'Vector2i':
				#continue
			if chunk[y][partial_chunk] == -1:
				continue
			var coord = Vector2i(x_tile, y)
			#BetterTerrain.set_cell(tilemap, layer, coord, 1)
			BetterTerrain.set_cell(tilemap, layer, coord, chunk[y][partial_chunk])
		BetterTerrain.update_terrain_area(tilemap, layer, Rect2i(x_tile, 1, x_tile, 10))
	else:
		for y in range(1,10):
			if type_string(typeof(chunk[y][partial_chunk])) != 'Vector2i':
				continue
			tilemap.set_cell(layer, Vector2i(x_tile,y), 0, chunk[y][partial_chunk], 0)
	
func generate_holes(x_offset):
	var hole_height = rng.randi_range(0, 2)
	var hole_y_offset = rng.randi_range(0, CHUNK_HEIGHT - hole_height)
	
	for y in range(y_offset + hole_y_offset, y_offset + hole_y_offset + hole_height):	
		var hole_width = rng.randi_range(2, 5)
		var hole_x_offset = rng.randi_range(0, floor(hole_width / 2))
		for x in range(x_offset + hole_x_offset, x_offset + hole_x_offset + hole_width):
			chunk_ground[y][x-x_offset] = 2
			#var coord = Vector2i(x, y)
			#BetterTerrain.set_cell(tilemap, BOTTOM, coord, 2)
			#BetterTerrain.update_terrain_area(tilemap, BOTTOM, Rect2i(coord.x, coord.y, coord.x, coord.y))
		
func delete_partial_chunk(x_offset):
	for y in range(0,10):
		var offset = Vector2i(x_offset, y)
		BetterTerrain.set_cell(tilemap, BOTTOM, offset, -1)
		BetterTerrain.set_cell(tilemap, STATION, offset, -1)
		BetterTerrain.set_cell(tilemap, OBSTACLES, offset, -1)
		BetterTerrain.set_cell(tilemap, UI, offset, -1)
		#tilemap.erase_cell(STATION, offset)
		BetterTerrain.set_cell(tilemap, RAILS, offset, -1)
		#tilemap.erase_cell(OBSTACLES, offset)
		#tilemap.erase_cell(UI, offset)

	
func generate_items(x_offset):
	for x in range(x_offset,x_offset + CHUNK_WIDTH,4):
		var fire_node = fire.instantiate()
		get_node("/root/World/TileMap").add_child(fire_node)
		#print(fire_node)
		#fire_node.set_position(Vector2(300,100))
		fire_node.set_position(Vector2((chunks_generated-1)*CHUNK_WIDTH + x*24,24*2.5))
# Generate the background of the game
func generate_background(x_offset):
	for x in range(x_offset, x_offset + CHUNK_WIDTH):
		for y in range(STATION_MAX, HEIGHT+1):
			#var coord = Vector2i(x,y)
			chunk_ground[y][x-x_offset] = 1
			#tilemap.set_cell(BOTTOM, coord, 0, GROUND_COORD, 0)
func generate_station_area(x_offset):
	for x in range(x_offset, x_offset + CHUNK_WIDTH):
		for y in range(0,STATION_MAX):
			chunk_station[y+1][x-x_offset] = STATION_BLOCKS[y]
			#tilemap.set_cell(STATION, Vector2i(x,y+1), 0, STATION_BLOCKS[y] ,0)
		
# Generate obstacles on top of the background
func generate_obstacles(x_offset):
	# Only generate obstacles on even columns
	for x in range(x_offset, x_offset + CHUNK_WIDTH, 2):
		# 60% chance of a column spawning obstacles
		if (roll(0.6)):
			# Prevent an impossible column of rocks
			var remaining_obstacles = 1
			
			for y in range(y_offset, y_offset + CHUNK_HEIGHT):
				var coord = Vector2i(x, y)
				
				if (remaining_obstacles > 0):
					# 20% chance of spawning a rock					
					if (roll(0.2)):
						chunk_obstacles[y][x-x_offset] = ROCK_COORD
						chunk_ground[y][x-x_offset] = 0
						#tilemap.set_cell(OBSTACLES, coord, 0, ROCK_COORD, 0)
						#BetterTerrain.set_cell(tilemap, BOTTOM, coord, 0)
						#BetterTerrain.update_terrain_area(tilemap, BOTTOM, Rect2i(coord.x, coord.y, coord.x, coord.y))
						remaining_obstacles -= 1
					
					# 5% chance of spawning a rail
					elif (roll(0.05)):
						chunk_rails[y][x-x_offset] = 3
						chunk_ground[y][x-x_offset] = 0
						#tilemap.set_cell(RAILS, coord, 0, RAIL_COORD, 0)
						#tilemap.set_cell(BOTTOM, coord, 0, GROUND_COORD, 0)
						#tilemap.set_cells_terrain_connect(BOTTOM, [coord], 0, 1)	
						#BetterTerrain.set_cell(tilemap, RAILS, coord, 3)
						#BetterTerrain.update_terrain_area(tilemap, RAILS, Rect2i(coord.x, coord.y, coord.x, coord.y) )
						##var cells = get_surrounding_cells(tilemap_mouse_coord)
#
						#BetterTerrain.set_cell(tilemap, BOTTOM, coord, 0)
						#BetterTerrain.update_terrain_area(tilemap, BOTTOM, Rect2i(coord.x, coord.y, coord.x, coord.y) )
					#elif (roll(0.2)):
						#BetterTerrain.set_cell(tilemap, BOTTOM, coord, 2)
						#BetterTerrain.update_terrain_area(tilemap, BOTTOM, Rect2i(coord.x-1, coord.y-1, coord.x+1, coord.y+1))

# Returns if the function wins or loses
# Based on the chance 0.00 to 1.00 (0% to 100%)
func roll(chance):
	var outcome = rng.randf_range(0, 1)
	return (outcome < chance) 
