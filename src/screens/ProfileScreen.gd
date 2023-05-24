extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var item_list = $ItemList
onready var email : LineEdit = $ItemList/LineEdit


func _ready() -> void:
	check_user_type()
	set_profile()

func set_profile():
	item_list.set_item_text(0, "Nome: " + PlayerData.name_user)
	item_list.set_item_text(1, "Cognome: " + PlayerData.surname_user)
	item_list.set_item_text(2, "Email: " + PlayerData.email)
	if PlayerData.user_type == "patient":
		item_list.set_item_text(3, "Highscore modalita' classica: " + str(PlayerData.highscore_first_mode))
		item_list.set_item_text(4, "Highscore modalita' runner: " + str(PlayerData.highscore_second_mode))
	elif PlayerData.user_type == "medic":
		item_list.set_item_text(3, "Codice medico: " + PlayerData.medic_code)

func check_user_type():
	if PlayerData.user_type == "patient":
		item_list.remove_item(5)
	elif PlayerData.user_type == "medic":
		item_list.remove_item(3)
		item_list.remove_item(3)

