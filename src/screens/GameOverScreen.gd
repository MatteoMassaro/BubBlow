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

var button_flag = 0 
var profile := {
	"name": {},
	"surname": {},
	"email": {},
	"type_user": {},
	"highscore_first_mode": {},
	"highscore_second_mode": {},
	"games_first_mode": {},
	"games_second_mode": {},
	"last_score_first_mode_1": {},
	"last_score_first_mode_2": {},
	"last_score_first_mode_3": {},
	"last_score_second_mode_1": {},
	"last_score_second_mode_2": {},
	"last_score_second_mode_3": {},
	"decibel_avg_first_mode_1": {},
	"decibel_avg_first_mode_2": {},
	"decibel_avg_first_mode_3": {},
	"breath_duration_first_mode_1": {},
	"breath_duration_first_mode_2": {},
	"breath_duration_first_mode_3": {},
	"game_duration_first_mode_1": {},
	"game_duration_first_mode_2": {},
	"game_duration_first_mode_3": {},
	"decibel_avg_second_mode_1": {},
	"decibel_avg_second_mode_2": {},
	"decibel_avg_second_mode_3": {},
	"breath_duration_second_mode_1": {},
	"breath_duration_second_mode_2": {},
	"breath_duration_second_mode_3": {},
	"game_duration_second_mode_1": {},
	"game_duration_second_mode_2": {},
	"game_duration_second_mode_3": {}
} 

func _ready():
	check_music()
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)
	set_score()
	yield(get_tree().create_timer(3.0), "timeout")
	save_data()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_over.wav")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	result_body = JSON.parse(body.get_string_from_ascii()).result as Dictionary
	get_data(result_body)

func set_score():
	yield(get_tree().create_timer(1.0),"timeout")
	score_text.text = "PUNTEGGIO: "
	score_number.text = "%s" % PlayerData.score
	explanation_text.bbcode_text = "[center]LA TECNICA RESPIRATORIA UTILIZZATA PER ESEGUIRE IL GIOCO FA PARTE DELLE TECNICHE DI DISOSTRUZIONE BRONCHIALE. QUESTI TIPI DI TECNICHE AGISCONO SULLA MOBILIZZAZIONE ED ELIMINAZIONE DELLE SECREZIONI BRONCHIALI PER LIBERARE LE VIE AEREE E PERMETTERE UNA CORRETTA RESPIRAZIONE POLMONARE.[/center]"
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
		explanation_text.bbcode_text = "[center]CONTINUA A GIOCARE PER MIGLIORARE LE TUE FUNZIONI RESPIRATORIE: UN SUGGERIMENTO PUO' ESSERE QUELLO DI RAGGIUNGERE UN PICCO NEL FLUSSO ESPIRATORIO (SOFFIARE AL MASSIMO DELLE TUE CAPACITA') PER FAVORIRE LO SPOSTAMENTO DELLE SECREZIONI. LA POSTURA CORRETTA DURANTE IL GIOCO CONTRIBUISCE NELLA TERAPIA PERCIO' CERCA DI MANTENERLA DURANTE LA PARTITA. [/center]"
		text_animations.play("show_explanation_text")
	else:
		next_button.text = "AVANTI"
		button_flag = 0
		explanation_text.bbcode_text = "[center]LA TECNICA RESPIRATORIA UTILIZZATA PER ESEGUIRE IL GIOCO FA PARTE DELLE TECNICHE DI DISOSTRUZIONE BRONCHIALE. QUESTI TIPI DI TECNICHE AGISCONO SULLA MOBILIZZAZIONE ED ELIMINAZIONE DELLE SECREZIONI BRONCHIALI PER LIBERARE LE VIE AEREE E PERMETTERE UNA CORRETTA RESPIRAZIONE POLMONARE.[/center]"
		text_animations.play("show_explanation_text")
	yield(get_tree().create_timer(3.0),"timeout")
	restart_button.self_modulate.a = 1
	menu_button.self_modulate.a = 1

func save_data():
	if(PlayerData.game_mode == 1):
		profile.name = {"stringValue": PlayerData.name_user}
		profile.surname = {"stringValue": PlayerData.surname_user}
		profile.email = { "stringValue": PlayerData.email}
		profile.type_user = { "stringValue": PlayerData.user_type }
		PlayerData.games_first_mode += 1
		#FIRST MODE
		if (PlayerData.score > PlayerData.highscore_first_mode):
			profile.highscore_first_mode = { "integerValue": PlayerData.score}
		else:
			profile.highscore_first_mode = { "integerValue": PlayerData.highscore_first_mode}
		profile.highscore_second_mode = { "integerValue": PlayerData.highscore_second_mode}
		profile.games_first_mode = { "integerValue": PlayerData.games_first_mode }
		profile.games_second_mode = { "integerValue": PlayerData.games_second_mode }
		if (PlayerData.games_first_mode == 1):
			profile.last_score_first_mode_1 = {"integerValue": PlayerData.score}
			profile.decibel_avg_first_mode_1 = {"doubleValue": PlayerData.decibel_avg_first_mode_1/PlayerData.breathe_counter}
			profile.game_duration_first_mode_1 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_first_mode_1 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.last_score_first_mode_2 = {"integerValue": PlayerData.last_score_first_mode_2}
			profile.decibel_avg_first_mode_2 = {"doubleValue": PlayerData.decibel_avg_first_mode_2}
			profile.game_duration_first_mode_2 = {"stringValue": PlayerData.game_duration_first_mode_2}
			profile.breath_duration_first_mode_2 = {"stringValue": PlayerData.breath_duration_first_mode_2}
			profile.last_score_first_mode_3 = {"integerValue": PlayerData.last_score_first_mode_3}
			profile.decibel_avg_first_mode_3 = {"doubleValue": PlayerData.decibel_avg_first_mode_3}
			profile.game_duration_first_mode_3 = {"stringValue": PlayerData.game_duration_first_mode_3}
			profile.breath_duration_first_mode_3 = {"stringValue": PlayerData.breath_duration_first_mode_3}
		elif (PlayerData.games_first_mode == 2):
			profile.last_score_first_mode_1 = {"integerValue": PlayerData.last_score_first_mode_1}
			profile.decibel_avg_first_mode_1 = {"doubleValue": PlayerData.decibel_avg_first_mode_1}
			profile.game_duration_first_mode_1 = {"stringValue": PlayerData.game_duration_first_mode_1}
			profile.breath_duration_first_mode_1 = {"stringValue": PlayerData.breath_duration_first_mode_1}
			profile.last_score_first_mode_2 = {"integerValue": PlayerData.score}
			profile.decibel_avg_first_mode_2 = {"doubleValue": PlayerData.decibel_avg_first_mode_2/PlayerData.breathe_counter}
			profile.game_duration_first_mode_2 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_first_mode_2 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.last_score_first_mode_3 = {"integerValue": PlayerData.last_score_first_mode_3}
			profile.decibel_avg_first_mode_3 = {"doubleValue": PlayerData.decibel_avg_first_mode_3}
			profile.game_duration_first_mode_3 = {"stringValue": PlayerData.game_duration_first_mode_3}
			profile.breath_duration_first_mode_3 = {"stringValue": PlayerData.breath_duration_first_mode_3}
		elif (PlayerData.games_first_mode >= 3):
			profile.last_score_first_mode_1 = {"integerValue": PlayerData.last_score_first_mode_1}
			profile.decibel_avg_first_mode_1 = {"doubleValue": PlayerData.decibel_avg_first_mode_1}
			profile.game_duration_first_mode_1 = {"stringValue": PlayerData.game_duration_first_mode_1}
			profile.breath_duration_first_mode_1 = {"stringValue": PlayerData.breath_duration_first_mode_1}
			profile.last_score_first_mode_2 = {"integerValue": PlayerData.last_score_first_mode_2}
			profile.decibel_avg_first_mode_2 = {"doubleValue": PlayerData.decibel_avg_first_mode_2}
			profile.game_duration_first_mode_2 = {"stringValue": PlayerData.game_duration_first_mode_2}
			profile.breath_duration_first_mode_2 = {"stringValue": PlayerData.breath_duration_first_mode_2}
			profile.last_score_first_mode_3 = {"integerValue": PlayerData.score}
			profile.decibel_avg_first_mode_3 = {"doubleValue": PlayerData.decibel_avg_first_mode_3/PlayerData.breathe_counter}
			profile.game_duration_first_mode_3 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_first_mode_3 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.games_first_mode = {"integerValue" : 0}
			PlayerData.games_first_mode = 0
		#SECOND MODE
		profile.last_score_second_mode_1 = {"integerValue": PlayerData.last_score_second_mode_1}
		profile.decibel_avg_second_mode_1 = {"doubleValue": PlayerData.decibel_avg_second_mode_1}
		profile.game_duration_second_mode_1 = {"stringValue": PlayerData.game_duration_second_mode_1}
		profile.breath_duration_second_mode_1 = {"stringValue": PlayerData.breath_duration_second_mode_1}
		profile.last_score_second_mode_2 = {"integerValue": PlayerData.last_score_second_mode_2}
		profile.decibel_avg_second_mode_2 = {"doubleValue": PlayerData.decibel_avg_second_mode_2}
		profile.game_duration_second_mode_2 = {"stringValue": PlayerData.game_duration_second_mode_2}
		profile.breath_duration_second_mode_2 = {"stringValue": PlayerData.breath_duration_second_mode_2}
		profile.last_score_second_mode_3 = {"integerValue": PlayerData.last_score_second_mode_3}
		profile.decibel_avg_second_mode_3 = {"doubleValue": PlayerData.decibel_avg_second_mode_3}
		profile.game_duration_second_mode_3 = {"stringValue": PlayerData.game_duration_second_mode_3}
		profile.breath_duration_second_mode_3 = {"stringValue": PlayerData.breath_duration_second_mode_3}
		print(profile)
		Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	elif (PlayerData.game_mode == 2):
		profile.name = {"stringValue": PlayerData.name_user}
		profile.surname = {"stringValue": PlayerData.surname_user}
		profile.email = { "stringValue": PlayerData.email}
		profile.type_user = { "stringValue": PlayerData.user_type }
		PlayerData.games_second_mode += 1
		#SECOND MODE
		if (PlayerData.score > PlayerData.highscore_second_mode):
			profile.highscore_second_mode = { "integerValue": PlayerData.score}
		else:
			profile.highscore_second_mode = { "integerValue": PlayerData.highscore_second_mode}
		profile.highscore_first_mode = { "integerValue": PlayerData.highscore_first_mode}
		profile.games_first_mode = { "integerValue": PlayerData.games_first_mode }
		profile.games_second_mode = { "integerValue": PlayerData.games_second_mode }
		if (PlayerData.games_second_mode == 1):
			profile.last_score_second_mode_1 = {"integerValue": PlayerData.score}
			profile.decibel_avg_second_mode_1 = {"doubleValue": PlayerData.decibel_avg_second_mode_1/PlayerData.breathe_counter}
			profile.game_duration_second_mode_1 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_second_mode_1 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.last_score_second_mode_2 = {"integerValue": PlayerData.last_score_second_mode_2}
			profile.decibel_avg_second_mode_2 = {"doubleValue": PlayerData.decibel_avg_second_mode_2}
			profile.game_duration_second_mode_2 = {"stringValue": PlayerData.game_duration_second_mode_2}
			profile.breath_duration_second_mode_2 = {"stringValue": PlayerData.breath_duration_second_mode_2}
			profile.last_score_second_mode_3 = {"integerValue": PlayerData.last_score_second_mode_3}
			profile.decibel_avg_second_mode_3 = {"doubleValue": PlayerData.decibel_avg_second_mode_3}
			profile.game_duration_second_mode_3 = {"stringValue": PlayerData.game_duration_second_mode_3}
			profile.breath_duration_second_mode_3 = {"stringValue": PlayerData.breath_duration_second_mode_3}
		elif (PlayerData.games_second_mode == 2):
			profile.last_score_second_mode_1 = {"integerValue": PlayerData.last_score_second_mode_1}
			profile.decibel_avg_second_mode_1 = {"doubleValue": PlayerData.decibel_avg_second_mode_1}
			profile.game_duration_second_mode_1 = {"stringValue": PlayerData.game_duration_second_mode_1}
			profile.breath_duration_second_mode_1 = {"stringValue": PlayerData.breath_duration_second_mode_1}
			profile.last_score_second_mode_2 = {"integerValue": PlayerData.score}
			profile.decibel_avg_second_mode_2 = {"doubleValue": PlayerData.decibel_avg_second_mode_2/PlayerData.breathe_counter}
			profile.game_duration_second_mode_2 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_second_mode_2 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.last_score_second_mode_3 = {"integerValue": PlayerData.last_score_second_mode_3}
			profile.decibel_avg_second_mode_3 = {"doubleValue": PlayerData.decibel_avg_second_mode_3}
			profile.game_duration_second_mode_3 = {"stringValue": PlayerData.game_duration_second_mode_3}
			profile.breath_duration_second_mode_3 = {"stringValue": PlayerData.breath_duration_second_mode_3}
		elif (PlayerData.games_second_mode >= 3):
			profile.last_score_second_mode_1 = {"integerValue": PlayerData.last_score_second_mode_1}
			profile.decibel_avg_second_mode_1 = {"doubleValue": PlayerData.decibel_avg_second_mode_1}
			profile.game_duration_second_mode_1 = {"stringValue": PlayerData.game_duration_second_mode_1}
			profile.breath_duration_second_mode_1 = {"stringValue": PlayerData.breath_duration_second_mode_1}
			profile.last_score_second_mode_2 = {"integerValue": PlayerData.last_score_second_mode_2}
			profile.decibel_avg_second_mode_2 = {"doubleValue": PlayerData.decibel_avg_second_mode_2}
			profile.game_duration_second_mode_2 = {"stringValue": PlayerData.game_duration_second_mode_2}
			profile.breath_duration_second_mode_2 = {"stringValue": PlayerData.breath_duration_second_mode_2}
			profile.last_score_second_mode_3 = {"integerValue": PlayerData.score}
			profile.decibel_avg_second_mode_3 = {"doubleValue": PlayerData.decibel_avg_second_mode_3/PlayerData.breathe_counter}
			profile.game_duration_second_mode_3 = {"stringValue": str(PlayerData.game_duration_minutes) + "m " + str(PlayerData.game_duration_seconds) + "s"}
			profile.breath_duration_second_mode_3 = {"stringValue": str(PlayerData.breath_duration_minutes) + "m " + str(PlayerData.breath_duration_seconds) + "s"}
			profile.games_second_mode = {"integerValue" : 0}
			PlayerData.games_second_mode = 0
		#FIRST MODE
		profile.last_score_first_mode_1 = {"integerValue": PlayerData.last_score_first_mode_1}
		profile.decibel_avg_first_mode_1 = {"doubleValue": PlayerData.decibel_avg_first_mode_1}
		profile.game_duration_first_mode_1 = {"stringValue": PlayerData.game_duration_first_mode_1}
		profile.breath_duration_first_mode_1 = {"stringValue": PlayerData.breath_duration_first_mode_1}
		profile.last_score_first_mode_2 = {"integerValue": PlayerData.last_score_first_mode_2}
		profile.decibel_avg_first_mode_2 = {"doubleValue": PlayerData.decibel_avg_first_mode_2}
		profile.game_duration_first_mode_2 = {"stringValue": PlayerData.game_duration_first_mode_2}
		profile.breath_duration_first_mode_2 = {"stringValue": PlayerData.breath_duration_first_mode_2}
		profile.last_score_first_mode_3 = {"integerValue": PlayerData.last_score_first_mode_3}
		profile.decibel_avg_first_mode_3 = {"doubleValue": PlayerData.decibel_avg_first_mode_3}
		profile.game_duration_first_mode_3 = {"stringValue": PlayerData.game_duration_first_mode_3}
		profile.breath_duration_first_mode_3 = {"stringValue": PlayerData.breath_duration_first_mode_3}
		print(profile)
		Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)

func get_data(result_body: Dictionary):
	if PlayerData.user_type == "patient":
		PlayerData.name_user = result_body.fields.name.stringValue 
		PlayerData.surname_user = result_body.fields.surname.stringValue
		PlayerData.email = result_body.fields.email.stringValue
		PlayerData.highscore_first_mode = result_body.fields.highscore_first_mode.integerValue
		PlayerData.highscore_second_mode = result_body.fields.highscore_second_mode.integerValue
		if(PlayerData.games_first_mode == 0):
			PlayerData.last_score_first_mode_2 = result_body.fields.last_score_first_mode_2.integerValue
			PlayerData.decibel_avg_first_mode_2 = result_body.fields.decibel_avg_first_mode_2.doubleValue
			PlayerData.game_duration_first_mode_2 = result_body.fields.game_duration_first_mode_2.stringValue
			PlayerData.breath_duration_first_mode_2 = result_body.fields.breath_duration_first_mode_2.stringValue
			PlayerData.last_score_first_mode_3 = result_body.fields.last_score_first_mode_3.integerValue
			PlayerData.decibel_avg_first_mode_3 = result_body.fields.decibel_avg_first_mode_3.doubleValue
			PlayerData.game_duration_first_mode_3 = result_body.fields.game_duration_first_mode_3.stringValue
			PlayerData.breath_duration_first_mode_3 = result_body.fields.breath_duration_first_mode_3.stringValue
		if(PlayerData.games_first_mode == 1):
			PlayerData.last_score_first_mode_1 = result_body.fields.last_score_first_mode_1.integerValue
			PlayerData.decibel_avg_first_mode_1 = result_body.fields.decibel_avg_first_mode_1.doubleValue
			PlayerData.game_duration_first_mode_1 = result_body.fields.game_duration_first_mode_1.stringValue
			PlayerData.breath_duration_first_mode_1 = result_body.fields.breath_duration_first_mode_1.stringValue
			PlayerData.last_score_first_mode_3 = result_body.fields.last_score_first_mode_3.integerValue
			PlayerData.decibel_avg_first_mode_3 = result_body.fields.decibel_avg_first_mode_3.doubleValue
			PlayerData.game_duration_first_mode_3 = result_body.fields.game_duration_first_mode_3.stringValue
			PlayerData.breath_duration_first_mode_3 = result_body.fields.breath_duration_first_mode_3.stringValue
		if(PlayerData.games_first_mode == 2):
			PlayerData.last_score_first_mode_1 = result_body.fields.last_score_first_mode_1.integerValue
			PlayerData.decibel_avg_first_mode_1 = result_body.fields.decibel_avg_first_mode_1.doubleValue
			PlayerData.game_duration_first_mode_1 = result_body.fields.game_duration_first_mode_1.stringValue
			PlayerData.breath_duration_first_mode_1 = result_body.fields.breath_duration_first_mode_1.stringValue
			PlayerData.last_score_first_mode_2 = result_body.fields.last_score_first_mode_2.integerValue
			PlayerData.decibel_avg_first_mode_2 = result_body.fields.decibel_avg_first_mode_2.doubleValue
			PlayerData.game_duration_first_mode_2 = result_body.fields.game_duration_first_mode_2.stringValue
			PlayerData.breath_duration_first_mode_2 = result_body.fields.breath_duration_first_mode_2.stringValue
		if(PlayerData.games_second_mode == 0):
			PlayerData.last_score_second_mode_2 = result_body.fields.last_score_second_mode_2.integerValue
			PlayerData.decibel_avg_second_mode_2 = result_body.fields.decibel_avg_second_mode_2.doubleValue
			PlayerData.game_duration_second_mode_2 = result_body.fields.game_duration_second_mode_2.stringValue
			PlayerData.breath_duration_second_mode_2 = result_body.fields.breath_duration_second_mode_2.stringValue
			PlayerData.last_score_second_mode_3 = result_body.fields.last_score_second_mode_3.integerValue
			PlayerData.decibel_avg_second_mode_3 = result_body.fields.decibel_avg_second_mode_3.doubleValue
			PlayerData.game_duration_second_mode_3 = result_body.fields.game_duration_second_mode_3.stringValue
			PlayerData.breath_duration_second_mode_3 = result_body.fields.breath_duration_second_mode_3.stringValue
		if(PlayerData.games_second_mode == 1):
			PlayerData.last_score_second_mode_1 = result_body.fields.last_score_second_mode_1.integerValue
			PlayerData.decibel_avg_second_mode_1 = result_body.fields.decibel_avg_second_mode_1.doubleValue
			PlayerData.game_duration_second_mode_1 = result_body.fields.game_duration_second_mode_1.stringValue
			PlayerData.breath_duration_second_mode_1 = result_body.fields.breath_duration_second_mode_1.stringValue
			PlayerData.last_score_second_mode_3 = result_body.fields.last_score_second_mode_3.integerValue
			PlayerData.decibel_avg_second_mode_3 = result_body.fields.decibel_avg_second_mode_3.doubleValue
			PlayerData.game_duration_second_mode_3 = result_body.fields.game_duration_second_mode_3.stringValue
			PlayerData.breath_duration_second_mode_3 = result_body.fields.breath_duration_second_mode_3.stringValue
		if(PlayerData.games_second_mode == 2):
			PlayerData.last_score_second_mode_1 = result_body.fields.last_score_second_mode_1.integerValue
			PlayerData.decibel_avg_second_mode_1 = result_body.fields.decibel_avg_second_mode_1.doubleValue
			PlayerData.game_duration_second_mode_1 = result_body.fields.game_duration_second_mode_1.stringValue
			PlayerData.breath_duration_second_mode_1 = result_body.fields.breath_duration_second_mode_1.stringValue
			PlayerData.last_score_second_mode_2 = result_body.fields.last_score_second_mode_2.integerValue
			PlayerData.decibel_avg_second_mode_2 = result_body.fields.decibel_avg_second_mode_2.doubleValue
			PlayerData.game_duration_second_mode_2 = result_body.fields.game_duration_second_mode_2.stringValue
			PlayerData.breath_duration_second_mode_2 = result_body.fields.breath_duration_second_mode_2.stringValue
