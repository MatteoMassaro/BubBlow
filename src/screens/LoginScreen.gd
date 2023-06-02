extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var email_field : LineEdit = $Menu1/MailField
onready var password_field : LineEdit = $Menu1/PasswordField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var user_type = ""
var flag = 0
var timer = Timer.new()
var hide_delay = 3.5

func _ready():
	set_timer()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func _on_LoginButton_pressed() -> void:
	if email_field.text.empty() or password_field.text.empty():
		notification.text = "PER FAVORE, INSERISCI EMAIL E PASSWORD"
		show_label()
		return
	Firebase.login(email_field.text, password_field.text, http)
	yield(get_tree().create_timer(2.0), "timeout")
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if (flag == 1):
		var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
		user_type = result_body.fields.type_user.stringValue
		PlayerData.user_type = user_type
		check_type(result_body)
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	else:
		if (flag == 1):
			notification.text = "LOGIN EFFETTUATO"
			show_label()
			yield(get_tree().create_timer(2.0), "timeout")
			get_tree().change_scene("res://src/screens/MenuScreen.tscn")
		flag = 1

func check_type(result_body: Dictionary):
	if PlayerData.user_type == "patient":
		PlayerData.name_user = result_body.fields.name.stringValue 
		PlayerData.surname_user = result_body.fields.surname.stringValue
		PlayerData.email = email_field.text
		PlayerData.highscore_first_mode = result_body.fields.highscore_first_mode.integerValue
		PlayerData.highscore_second_mode = result_body.fields.highscore_second_mode.integerValue
		PlayerData.games_first_mode = result_body.fields.games_first_mode.integerValue
		PlayerData.games_second_mode = result_body.fields.games_second_mode.integerValue
		PlayerData.last_score_first_mode_1 = result_body.fields.last_score_first_mode_1.integerValue
		PlayerData.last_score_first_mode_2 = result_body.fields.last_score_first_mode_2.integerValue
		PlayerData.last_score_first_mode_3 = result_body.fields.last_score_first_mode_3.integerValue
		PlayerData.last_score_second_mode_1 = result_body.fields.last_score_first_mode_1.integerValue
		PlayerData.last_score_second_mode_2 = result_body.fields.last_score_first_mode_2.integerValue
		PlayerData.last_score_second_mode_3 = result_body.fields.last_score_first_mode_3.integerValue
		PlayerData.decibel_avg_first_mode_1 = result_body.fields.decibel_avg_first_mode_1.doubleValue
		PlayerData.decibel_avg_second_mode_1 = result_body.fields.decibel_avg_second_mode_1.doubleValue
		PlayerData.game_duration_first_mode_1 = result_body.fields.game_duration_first_mode_1.stringValue
		PlayerData.game_duration_second_mode_1 = result_body.fields.game_duration_second_mode_1.stringValue
		PlayerData.breath_duration_first_mode_1 = result_body.fields.breath_duration_first_mode_1.stringValue
		PlayerData.breath_duration_second_mode_1 = result_body.fields.breath_duration_second_mode_1.stringValue
		PlayerData.decibel_avg_first_mode_2 = result_body.fields.decibel_avg_first_mode_2.doubleValue
		PlayerData.decibel_avg_second_mode_2 = result_body.fields.decibel_avg_second_mode_2.doubleValue
		PlayerData.game_duration_first_mode_2 = result_body.fields.game_duration_first_mode_2.stringValue
		PlayerData.game_duration_second_mode_2 = result_body.fields.game_duration_second_mode_2.stringValue
		PlayerData.breath_duration_first_mode_2 = result_body.fields.breath_duration_first_mode_2.stringValue
		PlayerData.breath_duration_second_mode_2 = result_body.fields.breath_duration_second_mode_2.stringValue
		PlayerData.decibel_avg_first_mode_3 = result_body.fields.decibel_avg_first_mode_3.doubleValue
		PlayerData.decibel_avg_second_mode_3 = result_body.fields.decibel_avg_second_mode_3.doubleValue
		PlayerData.game_duration_first_mode_3 = result_body.fields.game_duration_first_mode_3.stringValue
		PlayerData.game_duration_second_mode_3 = result_body.fields.game_duration_second_mode_3.stringValue
		PlayerData.breath_duration_first_mode_3 = result_body.fields.breath_duration_first_mode_3.stringValue
		PlayerData.breath_duration_second_mode_3 = result_body.fields.breath_duration_second_mode_3.stringValue
	elif PlayerData.user_type == "medic":
		PlayerData.name_user = result_body.fields.name.stringValue 
		PlayerData.surname_user = result_body.fields.surname.stringValue
		PlayerData.email = email_field.text
		PlayerData.medic_code = result_body.fields.medic_code.stringValue

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
