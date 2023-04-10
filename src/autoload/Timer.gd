extends Timer

var bubble_sprite = preload("res://src/Sprites/Bubble.tscn")

signal new_bubble

func _on_Timer_timeout():
	randomize()
	var bubble = bubble_sprite.instance()
	bubble.position = Vector2(rand_range(100,980), -400)
	add_child(bubble)
	emit_signal("new_bubble", bubble)
