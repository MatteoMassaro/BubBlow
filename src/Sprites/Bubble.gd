extends KinematicBody2D

onready var _bubble_sprite = $BubbleSprite
onready var points_up_animation = $PointsUpAnimation
onready var points_fade_animation = $PointsFadeAnimation
onready var throw_bubble_animation = $ThrowBubbleAnimation
onready var points = $Points

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 200.0
var _velocity: = Vector2.ZERO	
var body_entered


func _ready():
	body_entered = false

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

func throw_bubble():
	gravity = -400
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	yield(get_tree().create_timer(0.4), "timeout")
	self.visible = true
	throw_bubble_animation.play("scale_down_bubble")
	
func points_animation():
	points_up_animation.play("RESET")
	points_fade_animation.play("RESET")
	points_up_animation.play("points_up")
	points_fade_animation.play("points_fade")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/confirmation_003.ogg")
		AudioManager.play_effect()
