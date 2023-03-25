extends Control

export(String, FILE) var next_scene_path
onready var loadingBar : ProgressBar = $LoadingBar
onready var timer : Timer = $Timer
onready var text1 : Label = $Text1
onready var text2 : Label = $Text2
onready var text3 : Label = $Text3

var load_time = 3

func _on_Timer_timeout():
	loadingBar.value += 1
	if loadingBar.value == 20:
		text1.visible = true;
	elif loadingBar.value == 50:
		text2.visible = true;
	elif loadingBar.value == 70:
		text3.visible = true;
	if loadingBar.value == 100:
		get_tree().change_scene(next_scene_path)
