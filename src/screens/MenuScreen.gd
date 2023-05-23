extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var dynamic_button = $Menu/DynamicButton
onready var leaderboard_button = $LeaderboardButton

func _ready():
	check_music()
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)
	yield(get_tree().create_timer(1.0), "timeout")
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
	elif PlayerData.user_type == "doctor":
		dynamic_button.text = "DATI PAZIENTI"
		dynamic_button.next_scene_path = "res://src/screens/LeaderboardScreen.tscn"
		leaderboard_button.visible = false


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	PlayerData.user_type = result_body.fields.type_user.stringValue
	PlayerData.email = result_body.fields.email.stringValue
	if PlayerData.user_type == "patient":
		PlayerData.games = result_body.fields.games.integerValue
