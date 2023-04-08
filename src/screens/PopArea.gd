extends Area2D

onready var _bubble_sprite = get_node("../../Bubble")

var timer = load("res://src/autoload/Timer.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("new_bubble", timer, "_on_body_entered(Timer.bubble)")

func _on_body_entered(body):
	popBubble()

func popBubble():
	_bubble_sprite.popBubble()
