extends KinematicBody2D

onready var _duck_sprite = $DuckSprite
onready var points_up = $PointsUpAnimation
onready var points_fade = $PointsFadeAnimation
onready var points = $Points

const FLOOR_NORMAL: = Vector2.UP

var _velocity: = Vector2(100.0,0)	
var body_entered


func _ready():
	body_entered = false

func _process(delta):
	pass

func _physics_process(delta):
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func points_animation():
	points_up.play("RESET")
	points_fade.play("RESET")
	points_up.play("points_up")
	points_fade.play("points_fade")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/confirmation_003.ogg")
		AudioManager.play_effect()


func _on_DuckDetector_body_entered(body):
	_duck_sprite.play("die")
