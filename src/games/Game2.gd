extends Node2D


onready var pause_menu = $UserInterfaceLayer/UserInterface/PauseOverlay
onready var player = $Player
onready var tile_map = $TileMap
onready var enemy_spawn_timer = $EnemySpawnTimer

var record_bus_index: int
var volume_samples: Array = []
var sample_avg
var min_db = -10
var points = 1
var points_text = "+1"
var player_error = false

signal score_incremented

func _ready():
	check_music()
	record_bus_index = AudioServer.get_bus_index('Record')
	player.points.text = points_text

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _process(delta: float) -> void:
	connect("new_enemy", self, "_on_GameArea_body_entered")
	PlayerData.connect("life_counter_updated", self, "set_player_error")
	update_samples_strength()
	check_breathe()

func update_samples_strength() -> void:
	var sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(sample)

	sample_avg = average_array(volume_samples)
	
	while volume_samples.size() > 10:
		volume_samples.pop_back()
	
#	print("Sample average:", sample_avg)
#	print("Sample:", sample)
#	print("linearDb sample_avg:", linear2db(sample_avg))

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
	if (enemy.position.x < -150):
		enemy.free()

func update_score():
	PlayerData.score += points

func set_player_error():
	player_error = true
