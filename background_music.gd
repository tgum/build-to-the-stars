extends AudioStreamPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.music_play == true and playing == false:
		playing = true
	
	elif Globals.music_play == false:
		playing = false
