extends Button


func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()

func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	PlayerData.resume_game()
	PlayerData.reset()

func _on_RestartButton_pressed():
	if PlayerData.game_mode == 1:
		get_tree().change_scene("res://src/games/Game1.tscn")
	elif PlayerData.game_mode == 2:
		get_tree().change_scene("res://src/games/Game2.tscn")
