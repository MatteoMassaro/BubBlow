extends Control

onready var bubbles_saved_text : Label = $MenuContainer/Menu1/HMenu1/BubblesSavedText
onready var bubbles_saved_number : Label = $MenuContainer/Menu1/HMenu1/BubblesSavedNumber
onready var score_text : Label = $MenuContainer/Menu1/HMenu2/ScoreText
onready var score_number: Label = $MenuContainer/Menu1/HMenu2/ScoreNumber
onready var text_animations : AnimationPlayer = $TextAnimations

func _ready():
	check_music()
	set_bubbles_saved()
	set_score()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_over.wav")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func set_bubbles_saved():
	yield(get_tree().create_timer(0.5),"timeout")
	bubbles_saved_text.text = "BOLLE SALVATE: "
	bubbles_saved_number.text = "%s" % PlayerData.bubbles_saved
	text_animations.play("show_bubbles_saved_text")

func set_score():
	yield(get_tree().create_timer(2),"timeout")
	score_text.text = "PUNTEGGIO: "
	score_number.text= "%s" % PlayerData.score
	text_animations.play("show_score_text")
