extends AudioStreamPlayer
var was_focused = true
var playback_position: float = 0.0

func _ready():
	play()
	pass

func _process(delta):
	
	# if user unfocused the window remember where the music was and stop
	if was_focused and not OS.is_window_focused():
		playback_position = get_playback_position()
		stop()
	
	# if user refocused window play the music from where they left off
	if not was_focused and OS.is_window_focused():
		play(playback_position)
	
	# value will lag behind the real one by 1 frame
	was_focused = OS.is_window_focused()
	
	pass
