extends Area2D

onready var life_1 = get_tree().get_root().get_node("GameScreen/CanvasLayer/UserInterface/Life1")
onready var life_2 = get_tree().get_root().get_node("GameScreen/CanvasLayer/UserInterface/Life2")
onready var life_3 = get_tree().get_root().get_node("GameScreen/CanvasLayer/UserInterface/Life3")

var life_counter = 0

func _ready():
	connect("new_bubble", self, "_on_body_entered")

func _on_body_entered(body):
	var bubble = body
	bubble.pop_bubble()
	if life_counter == 0:
		life_1.pop_bubble()
		life_counter += 1
	elif life_counter == 1:
		life_2.pop_bubble()
		life_counter += 1
	elif life_counter == 2:
		life_3.pop_bubble()
		life_counter += 1
		PlayerData.deaths += 1
	
