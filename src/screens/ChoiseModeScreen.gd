extends Control

onready var first_mode_button = $ModeContainer/FirstModeMenu/FirstModeButton
onready var second_mode_button = $ModeContainer/SecondModeMenu/SecondModeButton


func _on_FirstModeButton_pressed():
	PlayerData.game_mode = 1

func _on_SecondModeButton_pressed():
	PlayerData.game_mode = 2

