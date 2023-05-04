extends KinematicBody2D

onready var _bubble_sprite = $BubbleSprite
onready var points_up = $PointsUpAnimation
onready var points_fade = $PointsFadeAnimation
onready var points = $Points

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 200.0
var _velocity: = Vector2.ZERO	
var body_entered


func _ready():
	body_entered = false

func _process(delta):
	connect("bubble_up", self, "move_bubble_up")

func _physics_process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func pop_bubble():
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_bubble_sprite.play("pop")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/bubblesounds/ES_Bubble Blip 1 - SFX Producer.mp3")
		AudioManager.play_effect()

func move_bubble_up():
	gravity = -1500
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func points_animation():
	points_up.play("RESET")
	points_fade.play("RESET")
	points_up.play("points_up")
	points_fade.play("points_fade")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/confirmation_003.ogg")
		AudioManager.play_effect()
