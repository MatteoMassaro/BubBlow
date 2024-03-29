extends Control

onready var pause_menu = $UserInterfaceLayer/UserInterface/PauseOverlay
onready var countdown_1 = $Countdown1
onready var countdown_2 = $Countdown2
onready var countdown_3 = $Countdown3
onready var breathe_alert = $BreatheAlert
onready var ok_alert = $OkAlert

var record_bus_index: int
var volume_samples: Array = []
var sample_avg
var min_db = -10
var points = 1
var game_time_start = 0
var game_time_elapsed = 0
var game_duration_seconds = 0
var game_duration_minutes = 0
var breath_duration_seconds = 0
var breath_duration_minutes = 0
var game_started = false

signal score_incremented

func _ready():
	check_music()
	set_countdown()
	record_bus_index = AudioServer.get_bus_index('Record')
	game_time_start = OS.get_unix_time()

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game1_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func set_countdown():
	countdown_3.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	countdown_3.visible = false
	countdown_2.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	countdown_2.visible = false
	countdown_1.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	countdown_1.visible = false
	game_started = true

func _process(delta: float) -> void:
	connect("new_bubble", self, "_on_MoveUpArea_body_entered")
	update_samples_strength()
	if game_started:
		save_breath_data()
		set_time_elapsed()

func update_samples_strength() -> void:
	var sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(sample)
	sample_avg = average_array(volume_samples)
	
	while volume_samples.size() > 10:
		volume_samples.pop_back()

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg

func _on_MoveUpArea_body_entered(body):
	var bubble = body
	if PlayerData.deaths <= 0:
		if bubble.body_entered == false:
			breathe_alert.visible = true
			ok_alert.visible = false
			if round(linear2db(sample_avg)) > min_db:
				breathe_alert.visible = false
				ok_alert.visible = true
				bubble.move_bubble_up()
				bubble.points_animation()
				update_score()
				bubble.body_entered = true
				yield(get_tree().create_timer(1.0), "timeout")
				breathe_alert.visible = false
				ok_alert.visible = false
	else:
		bubble.pop_bubble()

func update_score():
	PlayerData.score += points

func save_breath_data():
	PlayerData.decibel_avg += linear2db(sample_avg)
	PlayerData.breathe_counter += 1
	if round(linear2db(sample_avg)) > min_db:
		breath_duration_seconds += 0.018
		breath_duration_minutes = int(breath_duration_seconds/60)%60
	else:
		if(breath_duration_seconds > PlayerData.breath_duration_seconds):
			PlayerData.breath_duration_seconds = int(breath_duration_seconds)
			breath_duration_seconds = 0
		if(breath_duration_minutes > PlayerData.breath_duration_minutes):
			PlayerData.breath_duration_minutes = breath_duration_minutes
			breath_duration_minutes = 0

func set_time_elapsed():
	game_time_elapsed = OS.get_unix_time()
	game_duration_seconds = game_time_elapsed - game_time_start
	game_duration_minutes = (game_duration_seconds/60)%60
	PlayerData.game_duration_seconds = game_duration_seconds
	PlayerData.game_duration_minutes = game_duration_minutes 
