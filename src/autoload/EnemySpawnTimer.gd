extends Timer

var enemy_sprite1 = preload("res://src/sprites/Enemy1.tscn")
var enemy_sprite2 = preload("res://src/sprites/Enemy2.tscn")
var enemy_sprite3 = preload("res://src/sprites/Enemy3.tscn")

signal new_enemy

func _on_Timer_timeout():
	randomize()
	var enemy1 = enemy_sprite1.instance()
	var enemy2 = enemy_sprite2.instance()
	var enemy3 = enemy_sprite3.instance()
	enemy1.position = Vector2(rand_range(2000,2000), 1780)
	enemy2.position = Vector2(rand_range(2000,2000), 1780)
	enemy3.position = Vector2(rand_range(2000,2000), 1780)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var enemy_type = rng.randi_range(0, 3)
	if(enemy_type == 1):
		add_child(enemy1)
		emit_signal("new_enemy", enemy1)
	elif(enemy_type == 2):
		add_child(enemy2)
		emit_signal("new_enemy", enemy2)
	elif(enemy_type == 3):
		add_child(enemy3)
		emit_signal("new_enemy", enemy3)
