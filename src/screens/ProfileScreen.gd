extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var item_list = $ItemList
onready var email : LineEdit = $ItemList/LineEdit

var profile := {
	"email": {},
	"last_score": {}
} setget set_profile


func _ready() -> void:
	check_user_type()
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
	item_list.set_item_text(1, "Email: " + profile.email.stringValue)
	if PlayerData.user_type == "patient":
		item_list.set_item_text(2, "Highscore modalita' classica: " + profile.last_score.integerValue)

func check_user_type():
	if PlayerData.user_type == "patient":
		item_list.remove_item(4)
	elif PlayerData.user_type == "doctor":
		item_list.remove_item(2)
		item_list.remove_item(2)

