extends Control

onready var explanation_text= $MenuContainer/Menu/ExplanationText
onready var text_animations = $TextAnimations
onready var next_button = $MenuContainer/Menu3/NextButton
onready var back_button = $MenuContainer/Menu3/BackButton

var back_button_flag = 0

func _ready():
	show_explanation_text()

func show_explanation_text():
	back_button.next_scene_path = "res://src/screens/ChoiseModeScreen.tscn"
	explanation_text.bbcode_text = "[center]La tecnica respiratoria utilizzata per eseguire il gioco fa parte delle tecniche di disostruzione bronchiale.[/center]"
	text_animations.play("show_explanation_text")
	yield(get_tree().create_timer(3.0),"timeout")
	next_button.self_modulate.a = 1

func _on_NextButton_pressed():
	if back_button_flag == 1:
		next_button.next_scene_path = "res://src/screens/LoadingScreen.tscn"
		get_tree().change_scene(next_button.next_scene_path)
	else:
		back_button_flag = 1
		back_button.next_scene_path = ""
		next_button.self_modulate.a = 0
		next_button.text = "GIOCA"
		next_button.next_scene_path = ""
		text_animations.play("RESET")
		explanation_text.bbcode_text = "[center]Questi tipi di tecniche agiscono sulla mobilizzazione ed eliminazione delle secrezioni bronchiali per liberare le vie aeree e permettere una corretta respirazione polmonare.[/center]"
		text_animations.play("show_explanation_text")
		yield(get_tree().create_timer(3.0),"timeout")
		next_button.self_modulate.a = 1


func _on_BackButton_pressed():
	if back_button_flag == 0:
		back_button.next_scene_path = "res://src/screens/ChoiseModeScreen.tscn"
		get_tree().change_scene(back_button.next_scene_path)
	else:
		back_button_flag = 0
		back_button.next_scene_path = ""
		next_button.self_modulate.a = 0
		next_button.text = "AVANTI"
		next_button.next_scene_path = ""
		text_animations.play("RESET")
		explanation_text.bbcode_text = "[center]La tecnica respiratoria utilizzata per eseguire il gioco fa parte delle tecniche di disostruzione bronchiale.[/center]"
		text_animations.play("show_explanation_text")
		yield(get_tree().create_timer(3.0),"timeout")
		next_button.self_modulate.a = 1
	
