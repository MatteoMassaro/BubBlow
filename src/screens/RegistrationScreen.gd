extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_field: LineEdit = $Menu1/NameField
onready var surname_field: LineEdit = $Menu1/SurnameField
onready var email_field : LineEdit = $Menu1/MailField
onready var password_field : LineEdit = $Menu1/PasswordField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var information_sent := false
var flag = 0
var timer = Timer.new()
var hide_delay = 4
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
	check_microphone_permission()
	set_timer()

func check_microphone_permission():
	if OS.get_name() == "Android":
		OS.request_permissions()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func _on_RegisterButton_pressed() -> void:
	if name_field.text.empty():
		notification.text = "Inserisci nome"
		show_label()
		return
	if surname_field.text.empty():
		notification.text = "Inserisci cognome"
		show_label()
		return
	if email_field.text.empty():
		notification.text = "Inserisci email"
		show_label()
		return
	if password_field.text.empty():
		notification.text = "Inserisci password"
		show_label()
		return
	Firebase.register(email_field.text, password_field.text, http)
	yield(get_tree().create_timer(3.0), "timeout")
	create_profile()

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200 && flag == 0:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	elif flag == 0:
		notification.text = "REGISTRAZIONE COMPLETATA"
		show_label()
		flag = 1

func create_profile():
	PlayerData.name_user = name_field.text
	PlayerData.surname_user = surname_field.text
	PlayerData.user_type = "patient"
	PlayerData.email = email_field.text
	profile.name = { "stringValue": name_field.text }
	profile.surname = { "stringValue":  surname_field.text}
	profile.type_user = { "stringValue": "patient" }
	profile.email = { "stringValue": email_field.text}
	profile.highscore_first_mode = { "integerValue": 0 }
	profile.highscore_second_mode = { "integerValue": 0 }
	profile.games_first_mode = {"integerValue": 0 }
	profile.games_second_mode = {"integerValue": 0 }
	profile.last_score_first_mode_1 = {"integerValue": 0}
	profile.last_score_first_mode_2 = {"integerValue": 0}
	profile.last_score_first_mode_3 = {"integerValue": 0}
	profile.last_score_second_mode_1 = {"integerValue": 0}
	profile.last_score_second_mode_2 = {"integerValue": 0}
	profile.last_score_second_mode_3 = {"integerValue": 0}
	profile.decibel_avg_first_mode_1 = {"doubleValue": 0.0}
	profile.decibel_avg_first_mode_2 = {"doubleValue": 0.0}
	profile.decibel_avg_first_mode_3 = {"doubleValue": 0.0}
	profile.decibel_avg_second_mode_1 = {"doubleValue": 0.0}
	profile.decibel_avg_second_mode_2 = {"doubleValue": 0.0}
	profile.decibel_avg_second_mode_3 = {"doubleValue": 0.0}
	profile.breath_duration_first_mode_1 = {"stringValue": ""}
	profile.breath_duration_first_mode_2 = {"stringValue": ""}
	profile.breath_duration_first_mode_3 = {"stringValue": ""}
	profile.breath_duration_second_mode_1 = {"stringValue": ""}
	profile.breath_duration_second_mode_2 = {"stringValue": ""}
	profile.breath_duration_second_mode_3 = {"stringValue": ""}
	profile.game_duration_first_mode_1 = {"stringValue": ""}
	profile.game_duration_first_mode_2 = {"stringValue": ""}
	profile.game_duration_first_mode_3 = {"stringValue": ""}
	profile.game_duration_second_mode_1 = {"stringValue": ""}
	profile.game_duration_second_mode_2 = {"stringValue": ""}
	profile.game_duration_second_mode_3 = {"stringValue": ""}
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
