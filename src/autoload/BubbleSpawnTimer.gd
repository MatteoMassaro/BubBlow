extends Timer

var bubble_sprite = preload("res://src/sprites/Bubble.tscn")

var gravity = 0

signal new_bubble

func _on_Timer_timeout():
	if(wait_time > 1):
		self.wait_time -= 0.1
		gravity += 5
	randomize()
	var bubble = bubble_sprite.instance()
	bubble.position = Vector2(rand_range(100,980), -400)
	bubble.gravity += gravity
	add_child(bubble)
	emit_signal("new_bubble", bubble)
