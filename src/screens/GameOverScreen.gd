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

var button_flag = 0
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
	explanation_text.bbcode_text = "[center]LA TECNICA RESPIRATORIA UTILIZZATA PER ESEGUIRE IL GIOCO FA PARTE DELLE TECNICHE DI DISOSTRUZIONE BRONCHIALE. QUESTI TIPI DI TECNICHE AGISCONO SULLA MOBILIZZAZIONE ED ELIMINAZIONE DELLE SECREZIONI BRONCHIALI PER LIBERARE LE VIE AEREE E PERMETTERE UNA CORRETTA RESPIRAZIONE POLMONARE.[/center]"
	text_animations.play("show_score_text")
	yield(get_tree().create_timer(1.0),"timeout")
	text_animations.play("show_explanation_text")
	yield(get_tree().create_timer(3.0),"timeout")
	next_button.text = "AVANTI"
	next_button.self_modulate.a = 1
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
