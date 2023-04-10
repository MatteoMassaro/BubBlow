extends KinematicBody2D

onready var _bubble_sprite = $BubbleSprite
onready var sound_player = $FootSound

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 200.0
var _velocity: = Vector2.ZERO	

func _ready():
	connect("bubble_up", self, "moveBubbleUp")

func _physics_process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func popBubble():
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_bubble_sprite.play("pop")
	if AudioManager.flagEffects == 0:
		AudioManager.effect_track = load("res://assets/user interface/bubblesounds/ES_Bubble Blip 1 - SFX Producer.mp3")
		AudioManager.play_effect()

func moveBubbleUp():
	_velocity.y -= gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
