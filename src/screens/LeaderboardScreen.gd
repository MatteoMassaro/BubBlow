extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var leaderboard_scroll1 : ScrollContainer = $LeaderboardScroll1
onready var leaderboard_scroll2 : ScrollContainer = $LeaderboardScroll2
onready var leaderboard_scroll3 : ScrollContainer = $LeaderboardScroll3
onready var leaderboard_position_container1 : VBoxContainer = $LeaderboardScroll2/LeaderboardContainer/LeaderboardMedalContainer/LeaderboardPositionContainer
onready var leaderboard_name_container1: VBoxContainer = $LeaderboardScroll2/LeaderboardContainer/LeaderboardNameContainer
onready var leaderboard_score_container1: VBoxContainer = $LeaderboardScroll2/LeaderboardContainer/LeaderboardScoreContainer
onready var leaderboard_position_container2 : VBoxContainer = $LeaderboardScroll3/LeaderboardContainer/LeaderboardMedalContainer/LeaderboardPositionContainer
onready var leaderboard_name_container2: VBoxContainer = $LeaderboardScroll3/LeaderboardContainer/LeaderboardNameContainer
onready var leaderboard_score_container2: VBoxContainer = $LeaderboardScroll3/LeaderboardContainer/LeaderboardScoreContainer
onready var leaderboard_score_text : Label = $LeaderboardScroll1/LeaderboardContainer/LeaderboardScoreTextContainer/GameScore
onready var game_mode_button : Button = $GameModeButton

var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button = preload("res://src/user interface/DetailsButton.tscn")
var button_flag = 0


func _ready():
	remove_leaderboard_scrollbar()
	populate_leaderboard_positions()
	populate_leaderboard_names()
	PlayerData.game_mode = 1
	if PlayerData.user_type == "paziente":
		populate_leaderboard_scores()
	elif PlayerData.user_type == "medico":
		populate_leaderboard_buttons()

func remove_leaderboard_scrollbar():
	leaderboard_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll3.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll3.get_v_scrollbar().modulate = Color(0,0,0,0)

func populate_leaderboard_positions():
	for i in 20:
		if (i < 3):
			pass
		else:
			var leaderboard_text_instance = leaderboard_text.instance()
			var position = i + 1
			leaderboard_text_instance.text = "%s" % position
			leaderboard_position_container1.add_child(leaderboard_text_instance)
	for i in 30:
		if (i < 3):
			pass
		else:
			var leaderboard_text_instance = leaderboard_text.instance()
			var position = i + 1
			leaderboard_text_instance.text = "%s" % position
			leaderboard_position_container2.add_child(leaderboard_text_instance)

func populate_leaderboard_names():
	for i in 20:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		leaderboard_text_instance.text = "Matteo"
		leaderboard_name_container1.add_child(leaderboard_text_instance)
	for i in 30:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		leaderboard_text_instance.text = "Matteo"
		leaderboard_name_container2.add_child(leaderboard_text_instance)

func populate_leaderboard_scores():
	leaderboard_score_text.text = "HIGHSCORE"
	for i in 20:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.text = "1245"
		leaderboard_score_container1.add_child(leaderboard_text_instance)
	for i in 30:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.text = "5432"
		leaderboard_score_container2.add_child(leaderboard_text_instance)

func populate_leaderboard_buttons():
	leaderboard_score_text.text = "DATI"
	for i in 20:
		var leaderboard_details_button_instance = leaderboard_details_button.instance()
		leaderboard_score_container1.add_child(leaderboard_details_button_instance)
	for i in 30:
		var leaderboard_details_button_instance = leaderboard_details_button.instance()
		leaderboard_score_container2.add_child(leaderboard_details_button_instance)


func _on_GameModeButton_pressed():
	if button_flag == 0:
		game_mode_button.text = "MODALITA' 2"
		button_flag += 1
		leaderboard_scroll2.visible = false
		leaderboard_scroll3.visible = true
		PlayerData.game_mode = 2
	elif button_flag == 1:
		game_mode_button.text = "MODALITA' 1"
		button_flag -= 1
		leaderboard_scroll2.visible = true
		leaderboard_scroll3.visible = false
		PlayerData.game_mode = 1

