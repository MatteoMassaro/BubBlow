extends TileMap

onready var seabed_player = $SeabedPlayer


func move_seabed_first():
	seabed_player.play("move_seabed_first")

func move_other_seabed():
	seabed_player.play("move_other_seabed")
