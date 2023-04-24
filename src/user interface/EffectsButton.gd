extends CheckBox



func _on_button_up():
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
	if self.pressed == false:
		AudioManager.flag_effects = 1
		AudioManager.is_playing_effects = false
	elif self.pressed == true:
		AudioManager.flag_effects = 0
		AudioManager.is_playing_effects = true

