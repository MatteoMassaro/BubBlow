extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var dynamic_button = $Menu/DynamicButton
onready var leaderboard_button = $LeaderboardButton

func _ready():
	check_user_type()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.flag_music == 0:
		if AudioManager.music_button_pressed == false:
			if AudioManager.is_playing_music == false:
				AudioManager.play_music()

func check_user_type():
	if PlayerData.user_type == "patient":
		dynamic_button.text = "GIOCA"
		dynamic_button.next_scene_path = "res://src/screens/ChoiseScreen2.tscn"
	elif PlayerData.user_type == "medic":
		dynamic_button.text = "DATI PAZIENTI"
		dynamic_button.next_scene_path = "res://src/screens/LeaderboardScreen.tscn"
		leaderboard_button.visible = false
