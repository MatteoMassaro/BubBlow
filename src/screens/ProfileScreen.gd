extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var tipo_utente = ""
onready var notification = ""

var new_profile := false
var information_sent := false
var profile := {
	"tipo_utente": {}
} setget set_profile
	

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			notification.text = "Please, enter your information"
			new_profile = true
			return
		200:
			if information_sent:
				#notification.text = "Information saved successfully"
				information_sent = false
			self.profile = result_body.fields


func set_profile(value: Dictionary) -> void:
	profile = value
	tipo_utente = profile.tipo_utente.stringValue


func _on_Userbutton_pressed():
	profile.tipo_utente = { "stringValue": "user" }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/LoginScreen.tscn")


func _on_MedicButton_pressed():
	profile.tipo_utente = { "stringValue": "medic" }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://src/screens/LoginScreen.tscn")
