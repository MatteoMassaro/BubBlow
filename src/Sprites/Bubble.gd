extends KinematicBody2D

onready var _bubble_sprite = $BubbleSprite
onready var sound_player = $FootSound

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 250.0
var _velocity: = Vector2.ZERO	


#func _process(_delta):
#	if Input.is_action_pressed("move_right"):
#		if not TrackPlayer.effects_player.playing:
#			if TrackPlayer.flagEffects == 0:
#				TrackPlayer.steps_track = load("res://assets/user interface/kenney_impactsounds/Audio/footstep_grass.mp3")
#				TrackPlayer.play_steps()
#		_animated_sprite.flip_h = false
#		_animated_sprite.play("run")
#	elif Input.is_action_pressed("move_left"):
#		if not TrackPlayer.effects_player.playing:
#			if TrackPlayer.flagEffects == 0:
#				TrackPlayer.steps_track = load("res://assets/user interface/kenney_impactsounds/Audio/footstep_grass.mp3")
#				TrackPlayer.play_steps()
#		_animated_sprite.flip_h = true
#		_animated_sprite.play("run")
#	elif Input.is_action_pressed("jump"):
#		_animated_sprite.play("jump")
#	else:
#		TrackPlayer.stop_steps()
#		_animated_sprite.stop()
#		_animated_sprite.frame = 0

func _physics_process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func popBubble():
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_bubble_sprite.play("pop")

#func die():
#	PlayerData.deaths += 1
#	queue_free()
#	TrackPlayer.stop_steps()
#	TrackPlayer.stop_music()
#	if TrackPlayer.flagMusic == 0:
#		TrackPlayer.music_track = load("res://assets/user interface/Music/mixkit-funny-fail-low-tone-2876.wav")
#		TrackPlayer.play_music()
