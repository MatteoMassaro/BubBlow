extends Node2D


onready var pause_menu = $UserInterfaceLayer/UserInterface/PauseOverlay
onready var tile_map = $TileMap
onready var countdown_1 = $Countdown1
onready var countdown_2 = $Countdown2
onready var countdown_3 = $Countdown3
onready var background_layer_2 = $BackgroundLayer2
onready var animation_player = $AnimationPlayer
onready var smoke_1 = $BackgroundLayer2/Smoke1
onready var smoke_2 = $BackgroundLayer2/Smoke2
onready var smoke_3 = $BackgroundLayer2/Smoke3
onready var life_1 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life1")
onready var life_2 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life2")
onready var life_3 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life3")

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
var bubble_sprite = preload("res://src/sprites/Bubble.tscn")
var bubble
var duck
var game_started = false

func _ready():
	check_music()
	set_countdown()
	set_bubble()
	record_bus_index = AudioServer.get_bus_index('Record')
	game_time_start = OS.get_unix_time()

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

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game3_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _process(delta: float) -> void:
	connect("new_duck", self, "set_duck")
	PlayerData.connect("life_counter_updated", self, "set_player_error")
	update_samples_strength()
	if game_started:
		if(bubble != null):
			check_breathe(bubble)
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

func check_breathe(bubble):
	if (round(linear2db(sample_avg)) > min_db):
		set_smoke()
		bubble.throw_bubble()
	else:
		pass

func _on_GameArea_body_entered(body):
	bubble.pop_bubble()
	set_bubble()
	if PlayerData.life_counter == 0:
		life_1.pop_bubble()
		PlayerData.life_counter += 1
	elif PlayerData.life_counter == 1 && PlayerData.invincible == false:
		life_2.pop_bubble()
		PlayerData.life_counter += 1
	elif PlayerData.life_counter == 2 && PlayerData.invincible == false:
		life_3.pop_bubble()
		PlayerData.life_counter += 1
#		PlayerData.deaths += 1

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

func set_bubble():
	bubble = bubble_sprite.instance()
	bubble.visible = false
	bubble.position = Vector2(540, 1920)
	bubble.gravity = 0
	background_layer_2.add_child(bubble)
	emit_signal("new_bubble", bubble)

func set_duck(body):
	duck = body

func set_smoke():
	animation_player.play("set_smoke")
	smoke_1.visible = true
	smoke_2.visible = true
	smoke_3.visible = true

func _on_DuckArea_body_entered(body):
	if(duck != null):
		duck._on_DuckDetector_body_entered(body)
