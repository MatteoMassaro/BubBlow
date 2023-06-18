extends KinematicBody2D

onready var _fish_sprite = $FishSprite
onready var points_up = $PointsUpAnimation
onready var points_fade = $PointsFadeAnimation
onready var points = $Points

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 1000.0
var _velocity: = Vector2(-400, 0)	

func _process(delta):
	pass

func _physics_process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func die():
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_fish_sprite.play("die")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/bubblesounds/ES_Bubble Blip 1 - SFX Producer.mp3")
		AudioManager.play_effect()
