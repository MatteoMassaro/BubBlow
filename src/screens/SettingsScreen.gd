extends Control

onready var music_button: CheckBox = get_node("Menu/MusicButton")
onready var effects_button: CheckBox = get_node("Menu/EffectsButton")



func _ready():
	if AudioManager.is_playing_music == true:
		music_button.pressed = true
	elif AudioManager.is_playing_music == false:
		music_button.pressed = false
	if AudioManager.is_playing_effects == true:
		effects_button.pressed = true
	elif AudioManager.is_playing_effects == false:
		effects_button.pressed = false
