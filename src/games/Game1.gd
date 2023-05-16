extends Control

onready var volume_bar = $volume_bar #DA RIMUOVERE
onready var volume_value = $volume_value #DA RIMUOVERE
onready var pause_menu = $UserInterfaceLayer/UserInterface/PauseOverlay
onready var bubble_spawn_timer = $BubbleSpawnTimer

var record_bus_index: int
var volume_samples: Array = []
var sample_avg
var min_db = -10
var points = 1
var points_text = "+1"

signal score_incremented

func _ready():
	check_music()
	record_bus_index = AudioServer.get_bus_index('Record')

func check_music():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_music.mp3")
	if AudioManager.flag_music == 0:
		AudioManager.play_music()

func _process(delta: float) -> void:
	connect("new_bubble", self, "_on_MoveUpArea_body_entered")
	update_samples_strength()

func update_samples_strength() -> void:
	var sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(sample)

	sample_avg = average_array(volume_samples)
	volume_value.text = '%sdb' % round(linear2db(sample_avg))
	volume_bar.value = sample_avg
	
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

func _on_MoveUpArea_body_entered(body):
	var bubble = body
	if bubble.body_entered == false:
		if round(linear2db(sample_avg)) > min_db:
			bubble.points.text = points_text
			bubble.move_bubble_up()
			bubble.points_animation()
			update_score()
			bubble.body_entered = true

func update_score():
	PlayerData.score += points
	PlayerData.bubbles_saved += 1

func _on_BubbleIncreaseTimer_timeout():
	bubble_spawn_timer.wait_time = 1
	points_text = "+3"
	points = 3
