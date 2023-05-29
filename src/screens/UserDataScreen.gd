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
var last_score_first_mode_1 = 0
var last_score_first_mode_2 = 0
var last_score_first_mode_3 = 0
var last_score_second_mode_1 = 0
var last_score_second_mode_2 = 0
var last_score_second_mode_3 = 0
var decibel_avg_first_mode_1 = 0.0
var decibel_avg_second_mode_1 = 0.0
var breath_duration_first_mode_1 = ""
var breath_duration_second_mode_1 = ""
var game_duration_first_mode_1 = ""
var game_duration_second_mode_1 = ""
var decibel_avg_first_mode_2 = 0.0
var decibel_avg_second_mode_2 = 0.0
var breath_duration_first_mode_2 = ""
var breath_duration_second_mode_2 = ""
var game_duration_first_mode_2 = ""
var game_duration_second_mode_2 = ""
var decibel_avg_first_mode_3 = 0.0
var decibel_avg_second_mode_3 = 0.0
var breath_duration_first_mode_3 = ""
var breath_duration_second_mode_3 = ""
var game_duration_first_mode_3 = ""
var game_duration_second_mode_3 = ""

func _ready():
	remove_user_data_scrollbar()
	if(PlayerData.user_flag == 1):
		Firebase.get_document("users/%s" % PlayerData.user_id_1, http)
	elif(PlayerData.user_flag == 2):
		Firebase.get_document("users/%s" % PlayerData.user_id_2, http)
	elif(PlayerData.user_flag == 3):
		Firebase.get_document("users/%s" % PlayerData.user_id_3, http)
	yield(get_tree().create_timer(2.0), "timeout")
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
	last_score_first_mode_1 = result_body.fields.last_score_first_mode_1.integerValue
	last_score_second_mode_1 = result_body.fields.last_score_second_mode_1.integerValue
	decibel_avg_first_mode_1 = result_body.fields.decibel_avg_first_mode_1.doubleValue
	decibel_avg_second_mode_1 = result_body.fields.decibel_avg_second_mode_1.doubleValue
	breath_duration_first_mode_1 = result_body.fields.breath_duration_first_mode_1.stringValue
	breath_duration_second_mode_1 = result_body.fields.breath_duration_second_mode_1.stringValue
	game_duration_first_mode_1 = result_body.fields.game_duration_first_mode_1.stringValue
	game_duration_second_mode_1 = result_body.fields.game_duration_second_mode_1.stringValue
	last_score_first_mode_2 = result_body.fields.last_score_first_mode_2.integerValue
	last_score_second_mode_2 = result_body.fields.last_score_second_mode_2.integerValue
	decibel_avg_first_mode_2 = result_body.fields.decibel_avg_first_mode_2.doubleValue
	decibel_avg_second_mode_2 = result_body.fields.decibel_avg_second_mode_2.doubleValue
	breath_duration_first_mode_2 = result_body.fields.breath_duration_first_mode_2.stringValue
	breath_duration_second_mode_2 = result_body.fields.breath_duration_second_mode_2.stringValue
	game_duration_first_mode_2 = result_body.fields.game_duration_first_mode_2.stringValue
	game_duration_second_mode_2 = result_body.fields.game_duration_second_mode_2.stringValue
	last_score_first_mode_3 = result_body.fields.last_score_first_mode_3.integerValue
	last_score_second_mode_3 = result_body.fields.last_score_second_mode_3.integerValue
	decibel_avg_first_mode_3 = result_body.fields.decibel_avg_first_mode_3.doubleValue
	decibel_avg_second_mode_3 = result_body.fields.decibel_avg_second_mode_3.doubleValue
	breath_duration_first_mode_3 = result_body.fields.breath_duration_first_mode_3.stringValue
	breath_duration_second_mode_3 = result_body.fields.breath_duration_second_mode_3.stringValue
	game_duration_first_mode_3 = result_body.fields.game_duration_first_mode_3.stringValue
	game_duration_second_mode_3 = result_body.fields.game_duration_second_mode_3.stringValue

func remove_user_data_scrollbar():
	user_data_scroll1.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll1.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll2.get_v_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_h_scrollbar().modulate = Color(0,0,0,0)
	user_data_scroll3.get_v_scrollbar().modulate = Color(0,0,0,0)

func populate_user_data_games():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "1"
	user_data_game_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "2"
	user_data_game_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "3"
	user_data_game_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "1"
	user_data_game_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "2"
	user_data_game_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.text = "3"
	user_data_game_container2.add_child(leaderboard_text_instance)
	

func populate_user_data_decibels():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_first_mode_1 + "db"
	user_data_decibel_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_first_mode_2 + "db"
	user_data_decibel_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_first_mode_3 + "db"
	user_data_decibel_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_second_mode_1 + "db"
	user_data_decibel_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_second_mode_2 + "db"
	user_data_decibel_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = "%.3f" % decibel_avg_second_mode_3 + "db"
	user_data_decibel_container2.add_child(leaderboard_text_instance)

func populate_user_data_scores():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_first_mode_1)
	user_data_score_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_first_mode_2)
	user_data_score_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_first_mode_3)
	user_data_score_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_second_mode_1)
	user_data_score_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_second_mode_2)
	user_data_score_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = str(last_score_second_mode_3)
	user_data_score_container2.add_child(leaderboard_text_instance)


func populate_user_data_breath_durations():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_first_mode_1
	user_data_breath_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_first_mode_2
	user_data_breath_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_first_mode_3
	user_data_breath_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_second_mode_1
	user_data_breath_duration_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_second_mode_2
	user_data_breath_duration_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = breath_duration_second_mode_3
	user_data_breath_duration_container2.add_child(leaderboard_text_instance)

func populate_user_data_game_durations():
	var leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_first_mode_1
	user_data_game_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_first_mode_2
	user_data_game_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_first_mode_3
	user_data_game_duration_container1.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_second_mode_1
	user_data_game_duration_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_second_mode_2
	user_data_game_duration_container2.add_child(leaderboard_text_instance)
	leaderboard_text_instance = leaderboard_text.instance()
	leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
	leaderboard_text_instance.text = game_duration_second_mode_3
	user_data_game_duration_container2.add_child(leaderboard_text_instance)
