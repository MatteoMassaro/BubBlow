extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var user_data_scroll1 : ScrollContainer = $UserDataScroll1
onready var user_data_scroll2 : ScrollContainer = $UserDataScroll2
onready var user_data_scroll3 : ScrollContainer = $UserDataScroll3
onready var user_data_game_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataGameContainer
onready var user_data_decibel_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataDecibelContainer
onready var user_data_score_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataScoreContainer
onready var user_data_breath_duration_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataBreathDurationContainer
onready var user_data_game_duration_container1 : VBoxContainer = $UserDataScroll2/UserDataContainer/UserDataGameDurationContainer
onready var user_data_game_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataGameContainer
onready var user_data_decibel_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataDecibelContainer
onready var user_data_score_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataScoreContainer
onready var user_data_breath_duration_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataBreathDurationContainer
onready var user_data_game_duration_container2 : VBoxContainer = $UserDataScroll3/UserDataContainer/UserDataGameDurationContainer

var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button = preload("res://src/user interface/DetailsButton.tscn")
var games_first_mode = 0
var games_second_mode = 0
var highscore_first_mode = 0
var highscore_second_mode = 0
var decibel_avg_first_mode = 0.0
var decibel_avg_second_mode = 0.0
var breath_duration_first_mode = ""
var breath_duration_second_mode = ""
var game_duration_first_mode = ""
var game_duration_second_mode = ""

func _ready():
	Firebase.get_document("users/%s" % PlayerData.user_id_1, http)
	yield(get_tree().create_timer(2.0), "timeout")
	remove_user_data_scrollbar()
	populate_user_data_games()
	populate_user_data_decibels()
	populate_user_data_scores()
	populate_user_data_breath_durations()
	populate_user_data_game_durations()
	if PlayerData.game_mode == 1:
		user_data_scroll2.visible = true
		user_data_scroll3.visible = false
	elif PlayerData.game_mode == 2:
		user_data_scroll2.visible = false
		user_data_scroll3.visible = true

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	games_first_mode = result_body.fields.games_first_mode.integerValue
	games_second_mode = result_body.fields.games_second_mode.integerValue
	highscore_first_mode = result_body.fields.highscore_first_mode.integerValue
	highscore_second_mode = result_body.fields.highscore_second_mode.integerValue
	decibel_avg_first_mode = result_body.fields.decibel_avg_first_mode.doubleValue
	decibel_avg_second_mode = result_body.fields.decibel_avg_second_mode.doubleValue
	breath_duration_first_mode = result_body.fields.breath_duration_first_mode.stringValue
	breath_duration_second_mode = result_body.fields.breath_duration_second_mode.stringValue
	game_duration_first_mode = result_body.fields.game_duration_first_mode.stringValue
	game_duration_second_mode = result_body.fields.game_duration_second_mode.stringValue

func remove_user_data_scrollbar():
	user_data_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_v_scrollbar().modulate = Color(0,0,0,0)

func populate_user_data_games():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = str(games_first_mode)
	user_data_game_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = str(games_second_mode)
	user_data_game_container2.add_child(leaderboard_text_instance)

func populate_user_data_decibels():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_first_mode
	user_data_decibel_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_second_mode
	user_data_decibel_container2.add_child(leaderboard_text_instance)

func populate_user_data_scores():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(highscore_first_mode)
	user_data_score_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(highscore_second_mode)
	user_data_score_container2.add_child(leaderboard_text_instance)


func populate_user_data_breath_durations():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_first_mode
	user_data_breath_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_second_mode
	user_data_breath_duration_container2.add_child(leaderboard_text_instance)

func populate_user_data_game_durations():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_first_mode
	user_data_game_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_second_mode
	user_data_game_duration_container2.add_child(leaderboard_text_instance)
