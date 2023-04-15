extends Button

export(String, FILE) var next_scene_path: = ""

func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flagEffects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()


func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	AudioManager.music_button_pressed = false
	AudioManager.is_playing_music = false
	get_tree().change_scene(next_scene_path)
	get_tree().paused = false

func _get_configuration_warning():
	return "Next scene path must be set for the button to work" if next_scene_path == "" else ""
