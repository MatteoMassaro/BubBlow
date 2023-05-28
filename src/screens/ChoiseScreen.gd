extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
onready var patient_button : Button = $Menu/PatientButton
onready var medic_button : Button = $Menu/MedicButton

var name_user = ""
var surname_user = ""
var email = ""
var information_sent := false
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
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	name_user = result_body.fields.name.stringValue
	surname_user = result_body.fields.surname.stringValue
	email = result_body.fields.email.stringValue
	match response_code:
		404:
			notification.text = "Registration error"
			show_label()
			return
		200:
			if information_sent:
				notification.text = "Registration completed"
				show_label()
				information_sent = false


func _on_Userbutton_pressed():
	PlayerData.name_user = name_user
	PlayerData.surname_user = surname_user
	PlayerData.user_type = "patient"
	PlayerData.email = email
	profile.name = { "stringValue": name_user }
	profile.surname = { "stringValue": surname_user }
	profile.type_user = { "stringValue": "patient" }
	profile.email = { "stringValue": email}
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
	patient_button.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	yield(get_tree().create_timer(0.1), "timeout")
	patient_button.rect_scale = Vector2(1, 1)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")

func show_label():
	notification_panel.show()
