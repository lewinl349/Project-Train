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

# Size of background
const HEIGHT = 9
# Size of each playable chunk
const CHUNK_WIDTH = 10
const CHUNK_HEIGHT = 5
# Offset of the playable area
var y_offset = 2

func _ready():
	tilemap = get_parent()
	for x in range(0, CHUNK_WIDTH * 15, 10):
		generate_background(x)
		generate_obstacles(x)

# Generate the background of the game
func generate_background(x_offset):
	for x in range(x_offset, x_offset + CHUNK_WIDTH):
		for y in range(0, HEIGHT):
			var coord = Vector2i(x,y)
			tilemap.set_cell(BOTTOM, coord, 0, GROUND_COORD, 0)

# Generate obstacles on top of the background
func generate_obstacles(x_offset):
	# Only generate obstacles on even columns
	for x in range(x_offset, x_offset + CHUNK_WIDTH, 2):
		# 60% chance of a column spawning obstacles
		if (roll(0.6)):
			# Prevent an impossible column of rocks
			var remaining_obstacles = CHUNK_HEIGHT - 1
			
			for y in range(y_offset, y_offset + CHUNK_HEIGHT):
				var coord = Vector2i(x, y)
				
				if (remaining_obstacles > 0):
					# 20% chance of spawning a rock					
					if (roll(0.2)):
						tilemap.set_cell(OBSTACLES, coord, 0, ROCK_COORD, 0)
						tilemap.set_cell(BOTTOM, coord, 0, GROUND_COORD, 0)
						tilemap.set_cells_terrain_connect(BOTTOM, [coord], 0, 1)
						remaining_obstacles -= 1
					
					# 5% chance of spawning a rail
					elif (roll(0.05)):
						tilemap.set_cell(RAILS, coord, 0, RAIL_COORD, 0)
						tilemap.set_cell(BOTTOM, coord, 0, GROUND_COORD, 0)
						tilemap.set_cells_terrain_connect(BOTTOM, [coord], 0, 1)					

# Returns if the function wins or loses
# Based on the chance 0.00 to 1.00 (0% to 100%)
func roll(chance):
	var outcome = rng.randf_range(0, 1)
	return (outcome < chance) 
