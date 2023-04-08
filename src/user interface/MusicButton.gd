extends CheckBox


func _on_button_up():
	if AudioManager.flagEffects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	if self.pressed == false:
		AudioManager.stop_music()
		AudioManager.flagMusic = 1
	elif self.pressed == true:
			AudioManager.play_music()
			AudioManager.flagMusic = 0
			AudioManager.music_button_pressed = true

