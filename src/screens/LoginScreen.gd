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
	if Firebase.information_sent == true:
		Firebase.get_document("patients/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if (flag == 1):
		var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
		get_data(result_body)
	if response_code != 200:
		notification.text = response_body.result.error.message.to_upper()
		show_label()
	else:
		if (flag == 1):
			notification.text = "LOGIN EFFETTUATO"
			show_label()
			yield(get_tree().create_timer(2.0), "timeout")
			get_tree().change_scene("res://src/screens/MenuScreen.tscn")
		flag = 1

func get_data(result_body: Dictionary):
	PlayerData.name_user = result_body.fields.name.stringValue 
	PlayerData.surname_user = result_body.fields.surname.stringValue
	PlayerData.email = email_field.text
	PlayerData.games_first_mode_count = result_body.fields.games_first_mode_count.integerValue
	PlayerData.games_second_mode_count = result_body.fields.games_second_mode_count.integerValue
	PlayerData.highscore_first_mode = result_body.fields.highscore_first_mode.integerValue
	PlayerData.highscore_second_mode = result_body.fields.highscore_second_mode.integerValue

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
