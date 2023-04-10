extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: TextureRect = $PauseOverlay
onready var score: Label = $Score
onready var health: Label = $Health
onready var health_bar: ProgressBar = $HealthBar
onready var pause_menu: VBoxContainer = $PauseOverlay/MenuContainer
onready var check_music: CheckBox = $PauseOverlay/MenuContainer/Menu2/MusicButton
onready var check_effects: CheckBox = $PauseOverlay/MenuContainer/Menu2/EffectsButton

const DIED_MESSAGE: = "GAME OVER"

var paused: = false setget set_paused


func _ready():
	if AudioManager.is_playing_music == true:
		check_music.pressed = true
	elif AudioManager.is_playing_music == false:
		check_music.pressed = false
	if AudioManager.is_playing_effects == true:
		check_effects.pressed = true
	elif AudioManager.is_playing_effects == false:
		check_effects.pressed = false
	health.text = "SALUTE:"
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("game_resumed", self, "on_game_resumed")
	update_interface()


func _on_PlayerData_player_died():
	get_tree().change_scene_to(load('res://src/screens/MenuScreen.tscn'))

func _on_PauseButton_pressed():
	self.paused = not paused

func _on_ResumeButton_pressed():
	self.paused = not paused


func update_interface():
	score.text = "PUNTEGGIO: %s" % PlayerData.score
	if(health_bar.value == 33):
		health_bar.get("custom_styles/fg").bg_color = Color(255, 0, 0)
	if(health_bar.value == 66):
		health_bar.get("custom_styles/fg").bg_color = Color(255, 255, 0)
	elif(health_bar.value == 100):
		health_bar.get("custom_styles/fg").bg_color = Color(0, 255, 0)


func on_game_resumed(): 
	self.paused = not paused


func decrease_health_bar():
#	if HealthBar.enemy_counter == 1:
#		health_bar.value = 66
#	elif HealthBar.enemy_counter == 2:
#		health_bar.value = 33
	update_interface()

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
