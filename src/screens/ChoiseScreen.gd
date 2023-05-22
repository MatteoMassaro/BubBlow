extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var email = ""
onready var notification_panel : PanelContainer = $NotificationPanel
onready var notification : Label = $NotificationPanel/Notification
onready var patient_button : Button = $Menu/PatientButton
onready var doctor_button : Button = $Menu/DoctorButton

var information_sent := false
var profile := {
	"email": {},
	"type_user": {}
} 

func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	email = result_body.fields.email.stringValue
	match response_code:
		404:
			notification.text = "Please, enter your information"
			show_label()
			return
		200:
			if information_sent:
				notification.text = "Registrazione avvenuta con successo"
				show_label()
				information_sent = false


func _on_Userbutton_pressed():
	profile.type_user = { "stringValue": "patient" }
	profile.email = { "stringValue": email}
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


func _on_MedicButton_pressed():
	profile.type_user = { "stringValue": "doctor" }
	profile.email = { "stringValue": email}
	Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	doctor_button.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	yield(get_tree().create_timer(0.1), "timeout")
	doctor_button.rect_scale = Vector2(1, 1)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/MenuScreen.tscn")

func show_label():
	notification_panel.show()
