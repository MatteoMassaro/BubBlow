extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var name_field: LineEdit = $Menu1/NameField
onready var surname_field: LineEdit = $Menu1/SurnameField
onready var email_field : LineEdit = $Menu1/MailField
onready var password_field : LineEdit = $Menu1/PasswordField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification

var timer = Timer.new()
var hide_delay = 3.0
var profile := {
	"name": {},
	"surname": {},
	"email": {}
} 

func _ready():
	check_music()
	check_microphone_permission()
	set_timer()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/menu_music.mp3")
	if AudioManager.flag_music == 0:
		if AudioManager.is_playing_music == false:
			AudioManager.play_music()

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
		notification.text = "Insert name"
		show_label()
		return
	if surname_field.text.empty():
		notification.text = "Insert surname"
		show_label()
		return
	if email_field.text.empty():
		notification.text = "Insert email"
		show_label()
		return
	if password_field.text.empty():
		notification.text = "Insert password"
		show_label()
		return
	Firebase.register(email_field.text, password_field.text, http)
	yield(get_tree().create_timer(4.0), "timeout")
	profile.name = { "stringValue": name_field.text}
	profile.surname = { "stringValue": surname_field.text }
	profile.email = {"stringValue": email_field.text}
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/ChoiseScreen.tscn")
	

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		show_label()
	else:
		notification.text = "Registration successful"
		show_label()

func show_label():
	notification_panel.show()
	timer.start()

func hide_label():
	notification_panel.hide()
