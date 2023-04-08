extends Control


func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.music_button_pressed == false:
		AudioManager.play_music()
		AudioManager.music_button_pressed = true
