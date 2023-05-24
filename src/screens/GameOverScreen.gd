extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var score_text : Label = $MenuContainer/Menu1/ScoreText
onready var score_number: Label = $MenuContainer/Menu1/ScoreNumber
onready var text_animations : AnimationPlayer = $TextAnimations

onready var email = ""
onready var user_type = ""

var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"type_user": {},
	"highscore_first_mode": {},
	"highscore_second_mode": {},
	"last_score": {},
	"games": {}
} 

func _ready():
	check_music()
	set_score()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_over.wav")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func set_score():
	yield(get_tree().create_timer(1.0),"timeout")
	score_text.text = "PUNTEGGIO: "
	score_number.text = "%s" % PlayerData.score
	text_animations.play("show_score_text")
	profile.name = {"stringValue": PlayerData.name_user}
	profile.surname = {"stringValue": PlayerData.surname_user}
	profile.type_user = { "stringValue": PlayerData.user_type }
	profile.email = { "stringValue": PlayerData.email}
	profile.highscore_first_mode = { "integerValue": 0 }
	profile.highscore_second_mode = { "integerValue": 0 }
	profile.last_score = { "integerValue": PlayerData.score }
	PlayerData.games += 1
	profile.games = { "integerValue": PlayerData.games }
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
		var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
