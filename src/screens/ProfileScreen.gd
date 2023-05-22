extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var email : LineEdit = $ItemList/LineEdit

var profile := {
	"email": {}
} setget set_profile
	

func _ready() -> void:
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)
	

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			print("Informazioni non trovate")
			return
		200:
			self.profile = result_body.fields


func set_profile(value: Dictionary) -> void:
	profile = value
	email.text = profile.email.stringValue
