extends Area2D

var SPEED = 50;
var MAX_SPEED = 100
const SPEED_MULTIPLIER = 5.05

@onready var starting_offset = position.x
@onready var raycast = $RayCast2D
@onready var tilemap = get_node("/root/World/TileMap")

const GROUND_COORD = Vector2i(0,9) 

func _ready():
	
	pass

const max_slide_time = 1.5
var slide_time = 0

func _process(delta):
	
	#increase speed
	if(SPEED <= MAX_SPEED):
		SPEED += SPEED_MULTIPLIER * delta
	# check collision with hole or rock
	if raycast.is_colliding():
		load_death();
		get_tree().reload_current_scene()
		
	var adjusted_pos = Vector2(global_position.x - tilemap.position.x, global_position.y)
	if(BetterTerrain.get_cell(tilemap, 0, tilemap.local_to_map(adjusted_pos)) == 1):
		slide_time += delta
		SPEED -= (SPEED/max_slide_time)*delta
		if(slide_time >= max_slide_time):
			load_death()
			slide_time = 0
			get_tree().reload_current_scene()
	else:
		slide_time = 0

func load_death():
	print("You are dead")
	
func _input(event):
	if(event.is_action_pressed("left") and position.y >= 5*24):
		position.y -= 24
	if(event.is_action_pressed("right") and position.y <= 8*24):
		position.y += 24




