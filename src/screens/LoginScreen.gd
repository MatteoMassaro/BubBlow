extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var email : LineEdit = $MailField
onready var password : LineEdit = $PasswordField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var timer = Timer.new()
var hide_delay = 3.0

func _ready():
	set_timer()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func _on_LoginButton_pressed() -> void:
	if email.text.empty() or password.text.empty():
		notification.text = "Please, insert email and password"
		show_label()
		return
	Firebase.login(email.text, password.text, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	else:
		notification.text = "Login successful"
		show_label()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/MenuScreen.tscn")

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
