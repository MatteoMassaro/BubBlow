extends Area2D

signal remove_life

func _ready():
	connect("new_bubble", self, "_on_body_entered")

func _on_body_entered(body):
	var bubble = body
	emit_signal("remove_life")
	bubble.pop_bubble()
