extends Control

onready var http = $HTTPRequest
onready var score_text= $MenuContainer/Menu1/ScoreText
onready var score_number = $MenuContainer/Menu1/ScoreNumber
onready var explanation_text= $MenuContainer/Menu2/ExplanationText
onready var text_animations = $TextAnimations
onready var next_button = $MenuContainer/Menu3/NextButton
onready var restart_button = $MenuContainer/Menu3/RestartButton
onready var menu_button = $MenuContainer/Menu3/MenuButton
onready var email = ""
onready var user_type = ""
onready var result_body

var text_number = 0
var button_flag = 0 
var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"games_first_mode_count": {},
	"games_second_mode_count": {},
	"games_third_mode_count": {},
	"highscore_first_mode": {},
	"highscore_second_mode": {},
	"highscore_third_mode": {}
} 
var game := {
	"score": {},
	"decibel_avg": {},
	"breath_duration": {},
	"game_duration": {},
}

var text_1 = "[center]Continua a giocare per migliorare le tue funzioni respiratorie: raggiungere un picco nel flusso espiratorio durante la partita può favorire lo spostamento delle secrezioni.[/center]"
var text_2 = "[center]Per raggiungere il picco nel flusso espiratorio, inspira profondamente per riempire al massimo i polmoni e poi butta tutta l'aria fuori.[center]" 
var text_3 = "[center]Continua a giocare per migliorare le tue funzioni respiratorie: la postura corretta contribuisce nella terapia perciò cerca di mantenerla durante la partita.[/center]"
var text_4 = "[center]Per avere una postura corretta assicurati di mantenere sempre la schiena dritta e di non piegare la testa in avanti.[/center]"


func _ready():
	check_music()
	set_text()
	set_score()
	save_data()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_over.wav")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	result_body = JSON.parse(body.get_string_from_ascii()).result as Dictionary

func set_text():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	text_number = rng.randi_range(1, 2)

func set_score():
	yield(get_tree().create_timer(1.0),"timeout")
	score_text.text = "PUNTEGGIO: "
	score_number.text = "%s" % PlayerData.score
	if (text_number == 1):
		explanation_text.bbcode_text = text_1
	elif (text_number == 2):
		explanation_text.bbcode_text = text_3
	text_animations.play("show_score_text")
	yield(get_tree().create_timer(1.0),"timeout")
	text_animations.play("show_explanation_text")
	yield(get_tree().create_timer(3.0),"timeout")
	next_button.text = "AVANTI"
	next_button.self_modulate.a = 1

func _on_NextButton_pressed():
	if (button_flag == 0):
		next_button.text = "INDIETRO"
		button_flag = 1
		if (text_number == 1):
			explanation_text.bbcode_text = text_2
		elif (text_number == 2):
			explanation_text.bbcode_text = text_4
		text_animations.play("show_explanation_text")
	else:
		next_button.text = "AVANTI"
		button_flag = 0
		if (text_number == 1):
			explanation_text.bbcode_text = text_1
		elif (text_number == 2):
			explanation_text.bbcode_text = text_3
		text_animations.play("show_explanation_text")
	yield(get_tree().create_timer(3.0),"timeout")
	restart_button.self_modulate.a = 1
	menu_button.self_modulate.a = 1

func save_data():
	if(PlayerData.game_mode == 1):
		PlayerData.games_first_mode_count += 1
		if(PlayerData.score > PlayerData. highscore_first_mode):
			PlayerData.highscore_first_mode = PlayerData.score
		game.score = {"integerValue": PlayerData.score}
		game.decibel_avg = {"doubleValue": PlayerData.decibel_avg/PlayerData.breathe_counter}
		game.breath_duration = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
		game.game_duration = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
		Firebase.save_document("patients/%s/games_first_mode" % Firebase.user_info.id, game, http)
		yield(get_tree().create_timer(2.0), "timeout")
	if(PlayerData.game_mode == 2):
		PlayerData.games_second_mode_count += 1
		if(PlayerData.score > PlayerData. highscore_second_mode):
			PlayerData.highscore_second_mode = PlayerData.score
		game.score = {"integerValue": PlayerData.score}
		game.decibel_avg = {"doubleValue": PlayerData.decibel_avg/PlayerData.breathe_counter}
		game.breath_duration = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
		game.game_duration = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
		Firebase.save_document("patients/%s/games_second_mode" % Firebase.user_info.id, game, http)
		yield(get_tree().create_timer(2.0), "timeout")
	if(PlayerData.game_mode == 3):
		PlayerData.games_third_mode_count += 1
		if(PlayerData.score > PlayerData. highscore_third_mode):
			PlayerData.highscore_third_mode = PlayerData.score
		game.score = {"integerValue": PlayerData.score}
		game.decibel_avg = {"doubleValue": PlayerData.decibel_avg/PlayerData.breathe_counter}
		game.breath_duration = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
		game.game_duration = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
		Firebase.save_document("patients/%s/games_third_mode" % Firebase.user_info.id, game, http)
		yield(get_tree().create_timer(2.0), "timeout")
	profile.name = {"stringValue": PlayerData.name_user}
	profile.surname = {"stringValue":  PlayerData.surname_user}
	profile.email = {"stringValue": PlayerData.email}
	profile.games_first_mode_count = {"integerValue": PlayerData.games_first_mode_count}
	profile.games_second_mode_count = {"integerValue": PlayerData.games_second_mode_count}
	profile.games_third_mode_count = {"integerValue": PlayerData.games_third_mode_count}
	profile.highscore_first_mode = {"integerValue": PlayerData.highscore_first_mode}
	profile.highscore_second_mode = {"integerValue": PlayerData.highscore_second_mode}
	profile.highscore_third_mode = {"integerValue": PlayerData.highscore_third_mode}
	Firebase.update_document("patients/%s" % Firebase.user_info.id, profile, http)
