extends LineEdit

func _on_focus_entered():
	if AudioManager.flagEffects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()
