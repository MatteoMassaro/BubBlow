extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var medic_code : LineEdit = $Menu/MedicCodeField
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
onready var send_button : Button = $Menu/SendButton

var email = ""
var information_sent := false
var profile := {
	"email": {},
	"type_user": {},
	"medic_code": {}
} 

func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	email = result_body.fields.email.stringValue
	match response_code:
		404:
			notification.text = "Invalid code"
			show_label()
			return
		200:
			if information_sent:
				notification.text = "Registration completed"
				show_label()
				information_sent = false

func _on_SendButton_pressed():
	if medic_code.text.empty():
		notification.text = "Insert code"
		show_label()
		return
	profile.type_user = { "stringValue": "medic" }
	profile.email = { "stringValue": email}
	profile.medic_code = {"stringValue": medic_code.text}
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	PlayerData.user_type = "medic"
	PlayerData.email = email
	PlayerData.medic_code = medic_code.text
	send_button.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	yield(get_tree().create_timer(0.1), "timeout")
	send_button.rect_scale = Vector2(1, 1)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")

func show_label():
	notification_panel.show()
