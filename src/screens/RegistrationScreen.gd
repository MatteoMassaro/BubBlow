extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $MailField
onready var password : LineEdit = $PasswordField
onready var notification : Label = $Notification


func _on_RegisterButton_pressed() -> void:
	if username.text.empty() or password.text.empty():
		notification.text = "Email o password non validi"
		return
	Firebase.register(username.text, password.text, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		notification.text = "Registrazione effettuata"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://src/screens/LoginScreen.tscn")


func _on_AlreadyRegisteredButton_pressed():
	get_tree().change_scene("res://src/screens/LoginScreen.tscn")
