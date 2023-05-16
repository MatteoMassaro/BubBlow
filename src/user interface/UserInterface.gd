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
onready var health_position = Vector2(350,120)

var paused: = false setget set_paused


func _ready():
	check_music_button()
	check_effects_button()
	set_health()
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	PlayerData.connect("game_resumed", self, "on_game_resumed")
	set_life_gravity()
	update_interface()

func check_music_button():
	if AudioManager.is_playing_music == true:
		check_music.pressed = true
	elif AudioManager.is_playing_music == false:
		check_music.pressed = false

func check_effects_button():
	if AudioManager.is_playing_effects == true:
		check_effects.pressed = true
	elif AudioManager.is_playing_effects == false:
		check_effects.pressed = false

func set_health():
	health.set_position(health_position)
	health.text = "VITE:"

func set_life_gravity():
	life_1.gravity = 0
	life_2.gravity = 0
	life_3.gravity = 0

func update_interface():
	score.text = "PUNTEGGIO: %s" % PlayerData.score

func _on_PlayerData_player_died():
	yield(get_tree().create_timer(1.0), "timeout")
	scene_tree.paused = true
	get_tree().change_scene_to(load("res://src/screens/GameOverScreen.tscn"))
	scene_tree.paused = false

func _on_PauseButton_pressed():
	self.paused = not paused

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func on_game_resumed(): 
	self.paused = not paused
