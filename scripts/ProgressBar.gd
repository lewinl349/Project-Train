extends ProgressBar


# Called when the node enters the scene tree for the first time.
#func _ready():
	#await get_tree().create_timer(0)
#
#
#func change_progress(time):
	#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(value >= 1):
		print("alsjdka;sldk")
		$AnimationPlayer.play("new_animation")
	else:
		pass
			#get_theme_stylebox("fill").bg_color = Color.GREEN
