extends Control


onready var leaderboard_scroll : ScrollContainer = $LeaderboardScroll
onready var leaderboard_name_container: VBoxContainer = $LeaderboardScroll/LeaderboardContainer/LeaderboardNameContainer
onready var leaderboard_score_container: VBoxContainer = $LeaderboardScroll/LeaderboardContainer/LeaderboardScoreContainer
var leaderboard_text = preload("res://src/user interface/LeaderboardText.tscn")
var leaderboard_details_button = preload("res://src/user interface/DetailsButton.tscn")
var user_type = "medico"


func _ready():
	remove_leaderboard_scrollbar()
	populate_leaderboard_names()
	populate_leaderboard_scores()

func remove_leaderboard_scrollbar():
	leaderboard_scroll.get_h_scrollbar().modulate = Color(0,0,0,0)
	leaderboard_scroll.get_v_scrollbar().modulate = Color(0,0,0,0)

func populate_leaderboard_names():
	for i in 20:
		var leaderboard_text_instance = leaderboard_text.instance()
		leaderboard_text_instance.add_color_override("font_color", Color(255,255,255,255))
		var position = i + 1
		leaderboard_text_instance.text = "%s.  Matteo" % position
		leaderboard_name_container.add_child(leaderboard_text_instance)

func populate_leaderboard_scores():
	if user_type == "medico":
		for i in 20:
			var leaderboard_details_button_instance = leaderboard_details_button.instance()
			leaderboard_score_container.add_child(leaderboard_details_button_instance)
	elif user_type == "paziente":
		for i in 20:
			var leaderboard_text_instance = leaderboard_text.instance()
			leaderboard_text_instance.text = "1245"
			leaderboard_score_container.add_child(leaderboard_text_instance)
