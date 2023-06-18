extends Timer

var fish_sprite1 = preload("res://src/sprites/Fish1.tscn")
var fish_sprite2 = preload("res://src/sprites/Fish2.tscn")
var fish_sprite3 = preload("res://src/sprites/Fish3.tscn")

signal new_fish

func _on_Timer_timeout():
	self.wait_time -= 0.1
	randomize()
	var fish1 = fish_sprite1.instance()
	var fish2 = fish_sprite2.instance()
	var fish3 = fish_sprite3.instance()
	fish1.position = Vector2(2000, 1780)
	fish2.position = Vector2(2000, 1780)
	fish3.position = Vector2(2000, 1780)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var fish_type = rng.randi_range(1, 3)
	if(fish_type == 1):
		add_child(fish1)
		emit_signal("new_fish", fish1)
	elif(fish_type == 2):
		add_child(fish2)
		emit_signal("new_fish", fish2)
	elif(fish_type == 3):
		add_child(fish3)
		emit_signal("new_fish", fish3)
