extends Button

func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flagEffects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()


func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	PlayerData.resume_game()
