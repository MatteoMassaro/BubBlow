extends Node

signal score_updated
signal life_counter_updated
signal player_died
signal game_resumed

var game_mode = 0
var name_user = ""
var surname_user = ""
var email = ""
var user_type = ""
var medic_code = ""
var highscore_first_mode = 0
var highscore_second_mode = 0
var games: = 0
var score: = 0 setget set_score
var life_counter := 0 setget set_life_counter
var deaths: = 0 setget set_deaths
var player_flying = false
var invincible = false 
var decibel_avg = 0
var breathe_counter = 0
var game_duration_seconds = 0
var game_duration_minutes = 0
var breath_duration_seconds = 0
var breath_duration_minutes = 0



#func _ready():
	#Firebase.get_document("users/%s" % Firebase.user_info.id, http)

#func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	#var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	#email = result_body.fields.email.stringValue
	

func reset():
	score = 0
	life_counter = 0
	deaths = 0
	player_flying = false
	invincible = false
	decibel_avg = 0
	breathe_counter = 0
	game_duration_seconds = 0
	game_duration_minutes = 0


func set_score(value: int):
	score = value
	emit_signal("score_updated")

func set_life_counter(value: int):
	life_counter = value
	emit_signal("life_counter_updated")

func set_deaths(value: int):
	deaths = value
	emit_signal("player_died")

func resume_game():
	emit_signal("game_resumed")
