extends CheckBox


func _on_button_up():
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	if self.pressed == false:
		AudioManager.stop_music()
		AudioManager.flag_music = 1
	elif self.pressed == true:
			AudioManager.play_music()
			AudioManager.flag_music = 0
			AudioManager.music_button_pressed = true

