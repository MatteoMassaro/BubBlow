extends Control


func _on_FirstModeButton_pressed():
	PlayerData.game_mode = 1

func _on_SecondModeButton_pressed():
	PlayerData.game_mode = 2

func _on_ThirdModeButton_pressed():
	PlayerData.game_mode = 3
