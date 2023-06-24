extends Control


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
onready var breathe_alert = $BreatheAlert
onready var ok_alert = $OkAlert
onready var life_1 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life1")
onready var life_2 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life2")
onready var life_3 = get_tree().get_root().get_node("Game3/UserInterfaceLayer/UserInterface/Life3")

var record_bus_index: int
var volume_samples: Array = []
var sample_avg
var min_db = -10
var points = 1
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
var bubble_entered = false
var duck_entered = false
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
	PlayerData.connect("life_counter_updated", self, "set_player_error")
	connect("new_duck", self, "_on_DuckArea_body_entered")
	update_samples_strength()
	if game_started:
		if(bubble != null):
			check_breathe(bubble)
			bubble.connect("new_bubble", self, "_on_BubbleArea_body_entered")
			if(duck != null):
				if(bubble_entered && duck_entered):
					ok_alert.visible = false
					bubble_entered = false
					duck_entered = false
					duck.get_node("DuckSprite").play("die")
					duck._velocity = Vector2(0,0)
					bubble.pop_bubble()
					duck.points_animation()
					update_score()
					yield(get_tree().create_timer(1.0), "timeout")
					bubble.free()
					duck.free()
					set_bubble()
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
		breathe_alert.visible = false
		ok_alert.visible = true
		if(bubble.position == Vector2(540, 1920)):
			set_smoke()
			bubble.throw_bubble()

func _on_GameOverArea_body_entered(body):
	ok_alert.visible = false
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
		PlayerData.deaths += 1

func _on_BubbleArea_body_entered(body):
	bubble_entered = true
	bubble = body

func _on_DuckArea_body_entered(body):
	duck_entered = true
	duck = body

func _on_BubbleArea_body_exited(body):
	bubble_entered = false

func _on_DuckArea_body_exited(body):
	duck_entered = false

func _on_AlertArea_body_entered(body):
	breathe_alert.visible = true
	ok_alert.visible = false
	
func _on_AlertArea_body_exited(body):
	breathe_alert.visible = false

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
