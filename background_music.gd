extends AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.music_play == true:
		playing = true
	
	else:
		playing = false
