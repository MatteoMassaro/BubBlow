extends Node

signal score_updated
signal life_counter_updated
signal player_died
signal game_resumed

var score: = 0 setget set_score
var life_counter := 0 setget set_life_counter
var deaths: = 0 setget set_deaths
var player_flying = false
var invincible = false 
var game_mode = 0


func reset():
	score = 0
	life_counter = 0
	deaths = 0
	player_flying = false


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
