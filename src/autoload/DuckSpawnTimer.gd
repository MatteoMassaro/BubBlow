extends Timer

var duck_sprite1 = preload("res://src/sprites/Duck1.tscn")
var duck_sprite2 = preload("res://src/sprites/Duck2.tscn")
var duck_sprite3 = preload("res://src/sprites/Duck3.tscn")

var velocity = 0

signal new_duck

func _on_Timer_timeout():
	if(wait_time > 2):
		self.wait_time -= 0.1
		velocity += 10
	randomize()
	var duck1 = duck_sprite1.instance()
	var duck2 = duck_sprite2.instance()
	var duck3 = duck_sprite3.instance()
	duck1.position = Vector2(-20, 1135)
	duck1._velocity.x += velocity
	duck2.position = Vector2(-20, 1135)
	duck2._velocity.x += velocity
	duck3.position = Vector2(-20, 1135)
	duck3._velocity.x += velocity
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var duck_type = rng.randi_range(1, 3)
	if(duck_type == 1):
		add_child(duck1)
		emit_signal("new_duck", duck1)
	elif(duck_type == 2):
		add_child(duck2)
		emit_signal("new_duck", duck2)
	elif(duck_type == 3):
		add_child(duck3)
		emit_signal("new_duck", duck3)
