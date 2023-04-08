extends Area2D

var bubbleScript = load("res://src/Sprites/Bubble.gd")
var bubbleScriptInstance = bubbleScript.new()



func _ready():
	connect("new_bubble", self, "_on_body_entered")

func _on_body_entered(body):
	var bubble = body
	bubble.popBubble()

func popBubble():
	bubbleScriptInstance.popBubble()
