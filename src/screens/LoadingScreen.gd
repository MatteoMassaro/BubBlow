extends Control

export(String, FILE) var next_scene_path
onready var loadingBar : ProgressBar = $LoadingBar
onready var timer : Timer = $Timer
onready var text1 : Label = $Text1
onready var text2 : Label = $Text2
onready var text3 : Label = $Text3

var load_time = 3


func _on_Timer_timeout():
	loadingBar.value += 1
	if loadingBar.value == 20:
		if PlayerData.game_mode == 1:
			text1.text = "Rifornimento di ossigeno..."
			text1.visible = true;
		elif PlayerData.game_mode == 2:
			text1.text = "Rifornimento di ossigeno..."
			text1.visible = true;
	elif loadingBar.value == 50:
		if PlayerData.game_mode == 1:
			text2.text = "Caricamento dello sparabolle..."
			text2.visible = true;
		elif PlayerData.game_mode == 2:
			text2.text = "Caricamento del Jetpack..."
			text2.visible = true;
	elif loadingBar.value == 70:
		if PlayerData.game_mode == 1:
			text3.text = "Preparazione delle bolle..."
			text3.visible = true;
		elif PlayerData.game_mode == 2:
			text3.text = "Preparazione dei pesci..."
			text3.visible = true;
	if loadingBar.value == 100:
		if(PlayerData.game_mode == 1):
			get_tree().change_scene("res://src/games/Game1.tscn")
		elif(PlayerData.game_mode == 2):
			get_tree().change_scene("res://src/games/Game2.tscn")
