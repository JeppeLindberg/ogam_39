extends StaticBody3D

@onready var player = get_node('/root/main/player')

var control_enabled := false;

func handle_interact():
	player.control_enabled = false
	control_enabled = true


func handle_controls(_delta):
	if not control_enabled:
		return

