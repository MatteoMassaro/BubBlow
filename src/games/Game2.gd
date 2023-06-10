extends Node2D


onready var pause_menu = $UserInterfaceLayer/UserInterface/PauseOverlay
onready var player = $Player
onready var tile_map = $TileMap
onready var enemy_spawn_timer = $EnemySpawnTimer
onready var seabed_instance = preload("res://src/user interface/Seabed.tscn")
onready var countdown_1 = $Countdown1
onready var countdown_2 = $Countdown2
onready var countdown_3 = $Countdown3

var record_bus_index: int
var volume_samples: Array = []
var sample_avg
var min_db = -20
var points = 1
var points_text = "+1"
var player_error = false
var game_time_start = 0
var game_time_elapsed = 0
var game_duration_seconds = 0
var game_duration_minutes = 0
var breath_duration_seconds = 0
var breath_duration_minutes = 0

signal score_incremented

func _ready():
	check_music()
	set_countdown()
	record_bus_index = AudioServer.get_bus_index('Record')
	player.points.text = points_text
	game_time_start = OS.get_unix_time()
	create_first_seabed()
	create_multi_seabed()

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

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game2_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _process(delta: float) -> void:
	connect("new_enemy", self, "_on_GameArea_body_entered")
	PlayerData.connect("life_counter_updated", self, "set_player_error")
	update_samples_strength()
	check_breathe()
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

func check_breathe():
	if (round(linear2db(sample_avg)) > min_db && player.position.y > 1400):
		player.move_player_up()
	else:
		if(PlayerData.player_flying == true):
			player.move_player_down()
			if(player.position.y > 1698):
				player.run()

func _on_GameArea_body_entered(body):
	var enemy = body
	if (enemy.position.x < player.position.x && player_error == false):
		player.points_animation()
		update_score()
	else:
		player_error = false

func update_score():
	PlayerData.score += points

func set_player_error():
	player_error = true

func save_breath_data():
	PlayerData.decibel_avg += linear2db(sample_avg)
	PlayerData.breathe_counter += 1
	if round(linear2db(sample_avg)) > min_db:
			breath_duration_seconds += 0.018
			breath_duration_minutes = int(breath_duration_seconds/60)%60
			PlayerData.breath_duration_seconds = int(breath_duration_seconds)
			PlayerData.breath_duration_minutes = breath_duration_minutes

func set_time_elapsed():
	game_time_elapsed = OS.get_unix_time()
	game_duration_seconds = game_time_elapsed - game_time_start
	game_duration_minutes = (game_duration_seconds/60)%60
	PlayerData.game_duration_seconds = game_duration_seconds
	PlayerData.game_duration_minutes = game_duration_minutes

func create_first_seabed():
	var seabed_first = seabed_instance.instance()
	add_child(seabed_first)
	seabed_first.move_seabed_first()

func create_multi_seabed():
	while(true):
		yield(get_tree().create_timer(2.5), "timeout")
		var seabed = seabed_instance.instance()
		add_child(seabed)
		seabed.move_other_seabed()
