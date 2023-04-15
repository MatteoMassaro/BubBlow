extends Control

onready var volume_bar = $volume_bar
onready var volume_value = $volume_value
onready var pause_menu = $CanvasLayer/UserInterface/PauseOverlay

var record_bus_index: int
var volume_samples: Array = []

signal bubble_up

func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_music.mp3")
	if AudioManager.flagMusic == 0:
		AudioManager.play_music()
	check_microphone_permission()
	record_bus_index = AudioServer.get_bus_index('Record')

func check_microphone_permission():
	if OS.get_name() == "Android":
		OS.request_permissions()

func _process(delta: float) -> void:
	var funziona = AudioServer.is_bus_effect_enabled(record_bus_index, 0)
	print("funziona:", funziona)
	update_samples_strength()

func update_samples_strength() -> void:
	var sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(sample)

	var sample_avg = average_array(volume_samples)
	volume_value.text = '%sdb' % round(linear2db(sample_avg))
	volume_bar.value = sample_avg
	
	while volume_samples.size() > 10:
		volume_samples.pop_back()
	
	if round(linear2db(sample_avg)) > -5:
		connect("new_bubble", self, "move_bubble_up")
		volume_value.text = "funziona"
	else:
#		frequency_text.text = "spento"
		pass
	
#	print("Sample average:", sample_avg)
#	print("Sample:", sample)
#	print("linearDb sample_avg:", linear2db(sample_avg))

func move_bubble_up(bubble):
	emit_signal("bubble_up", bubble)

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
