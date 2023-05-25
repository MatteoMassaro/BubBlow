extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var dynamic_button = $Menu/DynamicButton
onready var leaderboard_button = $LeaderboardButton

func _ready():
	check_user_type()

func check_user_type():
	AudioManager.settings_button = false
	if PlayerData.user_type == "patient":
		dynamic_button.text = "GIOCA"
		dynamic_button.next_scene_path = "res://src/screens/ChoiseScreen2.tscn"
	elif PlayerData.user_type == "medic":
		dynamic_button.text = "DATI PAZIENTI"
		dynamic_button.next_scene_path = "res://src/screens/LeaderboardScreen.tscn"
		leaderboard_button.visible = false
