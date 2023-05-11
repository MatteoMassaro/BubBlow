extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username: LineEdit = $UsernameField
onready var email : LineEdit = $MailField
onready var password : LineEdit = $PasswordField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var timer = Timer.new()
var hide_delay = 3.0

func _ready():
	check_music()
	check_microphone_permission()
	set_timer()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()
		AudioManager.flag_music = 1

func check_microphone_permission():
	if OS.get_name() == "Android":
		OS.request_permissions()

func set_timer():
	add_child(timer)
	timer.set_wait_time(hide_delay)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "hide_label")

func _on_RegisterButton_pressed() -> void:
	if username.text.empty():
		notification.text = "Insert username"
		show_label()
		return
	if email.text.empty():
		notification.text = "Insert email"
		show_label()
		return
	if password.text.empty():
		notification.text = "Insert password"
		show_label()
		return
	Firebase.register(email.text, password.text, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	else:
		notification.text = "Registration successful"
		show_label()
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/ChoiseScreen.tscn")

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
