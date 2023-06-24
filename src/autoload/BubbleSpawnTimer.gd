extends Timer

var bubble_sprite = preload("res://src/sprites/Bubble.tscn")

signal new_bubble

func _on_Timer_timeout():
	if(wait_time > 1):
		self.wait_time -= 0.1
	randomize()
	var bubble = bubble_sprite.instance()
	bubble.position = Vector2(rand_range(100,980), -400)
	add_child(bubble)
	emit_signal("new_bubble", bubble)
