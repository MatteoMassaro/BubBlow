extends Control

onready var micInput = $MicrophoneInput
onready var frequency_text = $monitors/frequency_monitor/frequency_label

const MIN_DB: int = 80

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStreamSample
var record_live_index: int
var volume_samples: Array = []
var frequency_samples: Dictionary = {}
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
onready var label = get_node("Label")

signal bubble_up

func _ready():
	AudioManager.music_track = load ("res://assets/user interface/sounds/game_music.mp3")
	if AudioManager.flagMusic == 0:
			AudioManager.play_music()
	record_bus_index = AudioServer.get_bus_index('Record')
	# Only one effect on the bus, so can just assume index 0 for record effect
	record_effect = AudioServer.get_bus_effect(record_bus_index, 1)
	record_live_index = AudioServer.get_bus_index('Record')
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_live_index, 2)

func _process(delta: float) -> void:
	update_samples_strength()

func update_samples_strength() -> void:
	var sample = db2linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)

	var sample_avg = average_array(volume_samples)
#	volume_value.text = '%sdb' % round(linear2db(sample_avg))
#	volume_bar.value = sample_avg
	
	if round(linear2db(sample_avg)) > -5:
		emit_signal("bubble_up")
		label.text = "funziona"
	else:
#		frequency_text.text = "spento"
		pass

func _on_amp_spinbox_value_changed(value: float) -> void:
	micInput.volume_db = linear2db(value)

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
