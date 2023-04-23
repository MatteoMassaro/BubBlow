tool
extends Button

export(String, FILE) var next_scene_path: = ""


func _on_button_down():
	self.rect_scale = Vector2(0.8, 0.8)
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/drop_004.ogg")
		AudioManager.play_effect()

func _on_button_up():
	self.rect_scale = Vector2(1, 1)
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning():
	return "next_scene_path deve essere impostato per far funzionare il pulsante" if next_scene_path == "" else ""

