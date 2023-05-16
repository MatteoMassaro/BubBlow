extends KinematicBody2D

onready var _player_sprite = $PlayerSprite
onready var points_up = $PointsUpAnimation
onready var points_fade = $PointsFadeAnimation
onready var points = $Points
onready var life_1 = get_tree().get_root().get_node("Game2/UserInterfaceLayer/UserInterface/Life1")
onready var life_2 = get_tree().get_root().get_node("Game2/UserInterfaceLayer/UserInterface/Life2")
onready var life_3 = get_tree().get_root().get_node("Game2/UserInterfaceLayer/UserInterface/Life3")

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 200.0
var _velocity: = Vector2.ZERO


func _process(delta):
	connect("player_up", self, "move_player_up")

func _physics_process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func die():
	_velocity.y = 0
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	_player_sprite.play("die")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/bubblesounds/ES_Bubble Blip 1 - SFX Producer.mp3")
		AudioManager.play_effect()

func move_player_up():
	if PlayerData.deaths <= 0:
		gravity = -200
		_velocity.y += gravity * get_physics_process_delta_time()
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		if PlayerData.invincible == false:
			_player_sprite.play("fly")
		else:
			_player_sprite.play("fly_blink")
		PlayerData.player_flying = true
	else:
		gravity = 0
		_velocity = Vector2.ZERO
		_player_sprite.play("die")

func move_player_down():
	if PlayerData.deaths <= 0:
		gravity = 200
		_velocity.y += gravity * get_physics_process_delta_time()
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		if PlayerData.invincible == false:
			_player_sprite.play("fly")
		else:
			_player_sprite.play("fly_blink")
	else:
		gravity = 0
		_velocity = Vector2.ZERO
		_player_sprite.play("die")

func run():
	_player_sprite.play("run")
	PlayerData.player_flying = false

func points_animation():
	points_up.play("RESET")
	points_fade.play("RESET")
	points_up.play("points_up")
	points_fade.play("points_fade")
	if AudioManager.flag_effects == 0:
		AudioManager.effect_track = load("res://assets/user interface/sounds/kenney_interfacesounds/Audio/confirmation_003.ogg")
		AudioManager.play_effect()


func _on_EnemyDetector_body_entered(body):
	if PlayerData.life_counter == 0 && PlayerData.invincible == false:
		life_1.pop_bubble()
		PlayerData.life_counter += 1
		_player_sprite.play("run_blink")
		PlayerData.invincible = true
		yield(get_tree().create_timer(3.0), "timeout")
		_player_sprite.play("run")
		PlayerData.invincible = false
	elif PlayerData.life_counter == 1 && PlayerData.invincible == false:
		life_2.pop_bubble()
		PlayerData.life_counter += 1
		_player_sprite.play("run_blink")
		PlayerData.invincible = true
		yield(get_tree().create_timer(3.0), "timeout")
		_player_sprite.play("run")
		PlayerData.invincible = false
	elif PlayerData.life_counter == 2 && PlayerData.invincible == false:
		life_3.pop_bubble()
		PlayerData.life_counter += 1
		PlayerData.deaths += 1
		_player_sprite.play("die")
