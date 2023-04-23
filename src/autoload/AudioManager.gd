extends Node2D

var music_track = load("")
var effect_track = load("")
var steps_track = load("")
var is_playing_music
var is_playing_effects 
var flag_music = 0
var flag_effects = 0
var music_button_pressed = false

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


func play_object_effect():
	$Objects.stream = effect_track
	$Objects.play()


func stop_object_effect():
	$Objects.stop()


func play_enemie_effect():
	$Enemies.stream = effect_track
	$Enemies.play()


func stop_enemie_effect():
	$Enemies.stop()


func play_steps():
	$Steps.stream = steps_track
	$Steps.play()


func stop_steps():
	$Steps.stop()

