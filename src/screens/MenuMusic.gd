extends Control


func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.flag_music == 0:
		if AudioManager.music_button_pressed == false:
			if AudioManager.is_playing_music == false:
				AudioManager.play_music()
