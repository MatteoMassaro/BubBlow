extends Node2D

var music_track = load("")
var effect_track = load("")
var steps_track = load("")
var is_playing_music = false
var is_playing_effects
var flag_music = 0
var flag_effects = 0
var settings_button = false

func _ready():
	pass


func play_music():
	$MusicPlayer.stream = music_track
	$MusicPlayer.play()
	is_playing_music = true


func stop_music():
	$MusicPlayer.stop()
	is_playing_music = false


func play_effect():
	$EffectsPlayer.stream = effect_track
	$EffectsPlayer.play()


func stop_effect():
	$EffectsPlayer.stop()

