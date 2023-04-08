extends Timer

var bubbleSprite = preload("res://src/Sprites/Bubble.tscn")

var bubble

signal new_bubble

func _on_Timer_timeout():
	randomize()
	bubble = bubbleSprite.instance()
	bubble.position = Vector2(rand_range(10,990), -400)
	add_child(bubble)
	emit_signal("new_bubble")
