extends Control


func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()
	check_microphone_permission()

func check_microphone_permission():
	if OS.get_name() == "Android":
		OS.request_permissions()
