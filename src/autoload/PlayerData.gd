extends Node

signal score_updated
signal player_died
signal game_resumed

var score: = 0 setget set_score
var bubbles_saved := 0 setget set_bubbles_saved
var deaths: = 0 setget set_deaths


func reset():
	score = 0
	bubbles_saved = 0
	deaths = 0


func set_score(value: int):
	score = value
	emit_signal("score_updated")

func set_bubbles_saved(value: int):
	bubbles_saved = value

func set_deaths(value: int):
	deaths = value
	emit_signal("player_died")

func resume_game():
	emit_signal("game_resumed")
