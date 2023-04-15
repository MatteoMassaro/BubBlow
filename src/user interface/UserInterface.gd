extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: TextureRect = $PauseOverlay
onready var score: Label = $Score
onready var health: Label = $Health
onready var life_1: KinematicBody2D = $Life1
onready var life_2: KinematicBody2D = $Life2
onready var life_3: KinematicBody2D = $Life3
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
	var health_position = Vector2(350,120)
	health.set_position(health_position)
	health.text = "VITE:"
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("game_resumed", self, "on_game_resumed")
	connect("remove_life", self, "remove_lifes")
	life_1.gravity = 0
	life_2.gravity = 0
	life_3.gravity = 0
	update_interface()

func _on_PlayerData_player_died():
	get_tree().change_scene_to(load('res://src/screens/MenuScreen.tscn'))

func _on_PauseButton_pressed():
	self.paused = not paused

func update_interface():
	score.text = "PUNTEGGIO: %s" % PlayerData.score

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func on_game_resumed(): 
	self.paused = not paused

func remove_lifes():
	life_1.pop_bubble()
