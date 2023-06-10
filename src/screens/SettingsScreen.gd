extends Control

onready var menu: VBoxContainer = $Menu
onready var music_button: CheckBox = get_node("Menu/MusicButton")
onready var effects_button: CheckBox = get_node("Menu/EffectsButton")



func _ready():
	check_music_button()
	check_effects_button()

func check_music_button():
	AudioManager.settings_button = true
	if AudioManager.flag_music == 0:
		music_button.pressed = true
	elif AudioManager.flag_music == 1:
		music_button.pressed = false

func check_effects_button():
	if AudioManager.flag_effects == 0:
		effects_button.pressed = true
	elif AudioManager.flag_effects == 1:
		effects_button.pressed = false
		
