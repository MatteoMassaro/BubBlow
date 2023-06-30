extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var item_list = $ItemList
onready var email : LineEdit = $ItemList/LineEdit


func _ready() -> void:
	set_profile()

func set_profile():
	item_list.set_item_text(0, "Nome: " + PlayerData.name_user)
	item_list.set_item_text(1, "Cognome: " + PlayerData.surname_user)
	item_list.set_item_text(2, "Email: " + PlayerData.email)
	item_list.set_item_text(3, "Highscore livello bolle: " + str(PlayerData.highscore_first_mode))
	item_list.set_item_text(4, "Highscore livello runner: " + str(PlayerData.highscore_second_mode))
	item_list.set_item_text(5, "Highscore livello bersagli: " + str(PlayerData.highscore_third_mode))

