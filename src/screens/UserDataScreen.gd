extends Control


onready var user_data_scroll1 : ScrollContainer = $UserDataScroll1
onready var user_data_scroll2 : ScrollContainer = $UserDataScroll2
onready var user_data_scroll3 : ScrollContainer = $UserDataScroll3
onready var user_data_game_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataGameContainer
onready var user_data_decibel_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataDecibelContainer
onready var user_data_score_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataScoreContainer
onready var user_data_duration_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataDurationContainer
onready var user_data_game_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataGameContainer
onready var user_data_decibel_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataDecibelContainer
onready var user_data_score_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataScoreContainer
onready var user_data_duration_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataDurationContainer
var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button = preload("res://src/user interface/DetailsButton.tscn")


func _ready():
	remove_user_data_scrollbar()
	populate_user_data_games()
	populate_user_data_decibels()
	populate_user_data_scores()
	populate_user_data_durations()
	if PlayerData.game_mode == 1:
		user_data_scroll2.visible = true
		user_data_scroll3.visible = false
	elif PlayerData.game_mode == 2:
		user_data_scroll2.visible = false
		user_data_scroll3.visible = true

func remove_user_data_scrollbar():
	user_data_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_v_scrollbar().modulate = Color(0,0,0,0)

func populate_user_data_games():
	for i in 20:
			var leaderboard_text_instance = leaderboard_text.instance()
			var num_game = i + 1
			leaderboard_text_instance.text = "%s" % num_game
			user_data_game_container1.add_child(leaderboard_text_instance)
	for i in 30:
			var leaderboard_text_instance = leaderboard_text.instance()
			var num_game = i + 1
			leaderboard_text_instance.text = "%s" % num_game
			user_data_game_container2.add_child(leaderboard_text_instance)

func populate_user_data_decibels():
	for i in 20:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		#leaderboard_text_instance.text = str(PlayerData.decibel_avg/PlayerData.breathe_counter)
		user_data_decibel_container1.add_child(leaderboard_text_instance)
	for i in 30:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		#leaderboard_text_instance.text = str(PlayerData.decibel_avg/PlayerData.breathe_counter)
		user_data_decibel_container2.add_child(leaderboard_text_instance)

func populate_user_data_scores():
	for i in 20:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		leaderboard_text_instance.text = str(PlayerData.score)
		user_data_score_container1.add_child(leaderboard_text_instance)
	for i in 30:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		leaderboard_text_instance.text = str(PlayerData.score)
		user_data_score_container2.add_child(leaderboard_text_instance)

func populate_user_data_durations():
		for i in 20:
			var leaderboard_text_instance = leaderboard_text.instance()
			leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
			leaderboard_text_instance.text = str(PlayerData.game_duration_minutes) + " m " + str(PlayerData.game_duration_seconds) + " s "
			user_data_duration_container1.add_child(leaderboard_text_instance)
		for i in 30:
			var leaderboard_text_instance = leaderboard_text.instance()
			leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
			leaderboard_text_instance.text = str(PlayerData.game_duration_minutes) + " m " + str(PlayerData.game_duration_seconds) + " s "
			user_data_duration_container2.add_child(leaderboard_text_instance)
		
