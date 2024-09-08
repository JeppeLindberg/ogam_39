extends StaticBody3D

@onready var player = get_node('/root/main/player')
@onready var submarine = get_parent()
@onready var player_holder = get_node('player_holder')
@onready var main = get_node('/root/main')



func handle_interact():
	player.control_enabled = false
	player.reparent(player_holder)
	player.position = Vector3.ZERO;
	player.axis_lock_linear_x = true;
	player.axis_lock_linear_y = true;
	player.axis_lock_linear_z = true;
	player.axis_lock_angular_x = true;
	player.axis_lock_angular_y = true;
	player.axis_lock_angular_z = true;
	submarine.control_enabled = true;



	
