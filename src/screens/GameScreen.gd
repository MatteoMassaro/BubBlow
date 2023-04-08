extends Control

func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_music.mp3")
	if AudioManager.flagMusic == 0:
			AudioManager.play_music()



