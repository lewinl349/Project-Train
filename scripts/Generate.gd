extends Node

const BOTTOM = 0
const RAILS = 1
const OBSTACLES = 2
const UI = 3

const WIDTH = 10
const HEIGHT = 5
const Y_OFFSET = 2

var ground_coord = Vector2i(1,6)
var rock_coord = Vector2i(0,2)
var rail_coord = Vector2i(0,0)
var rng = RandomNumberGenerator.new()

var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_parent()
	for x in range(10, 150, 10):
		generate_background(x)
		generate_obstacles(x)

# Generate the background of the game
func generate_background(x_offset):
	for x in range(x_offset, x_offset + WIDTH):
		for y in range(0, HEIGHT + 4):
			var coord = Vector2i(x,y)
			tilemap.set_cell(BOTTOM, coord, 0, ground_coord, 0)

# Generate obstacles on top of the background
func generate_obstacles(x_offset):
	for x in range(x_offset, x_offset + WIDTH):
		# 30% chance of a column spawning obstacles
		if (roll(0.3)):
			# Prevent an impossible column of rocks
			var remaining_obstacles = 2
			for y in range(Y_OFFSET, Y_OFFSET + HEIGHT):
				if (remaining_obstacles > 0):
					# 30% chance of spawning a rock
					var coord = Vector2i(x, y)
					if (roll(0.3)):
						tilemap.set_cell(OBSTACLES, coord, 0, rock_coord, 0)
						remaining_obstacles -= 1
					# 8% chance of spawning a rail
					elif (roll(0.08)):
						tilemap.set_cell(RAILS, coord, 0, rail_coord, 0)
						tilemap.set_cell(BOTTOM, coord, 0, ground_coord, 0)
						tilemap.set_cells_terrain_connect(BOTTOM, [coord], 0, 1)					

# Returns if the function wins or loses
# Based on the chance (0% to 100%)
func roll(chance):
	var roll = rng.randf_range(0, 1)
	return (roll < chance) 
