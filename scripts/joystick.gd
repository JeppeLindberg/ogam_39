extends StaticBody3D

@onready var player = get_node('/root/main/player')
@onready var submarine = get_parent()
@onready var player_holder = get_node('player_holder')
@onready var main = get_node('/root/main')

var control_enabled := false;


func handle_interact():
	player.control_enabled = false
	control_enabled = true
	player.reparent(player_holder)
	player.position = Vector3.ZERO;
	player.axis_lock_linear_x = true;
	player.axis_lock_linear_y = true;
	player.axis_lock_linear_z = true;
	player.axis_lock_angular_x = true;
	player.axis_lock_angular_y = true;
	player.axis_lock_angular_z = true;

func _physics_process(delta):
	handle_controls(delta)

func handle_controls(_delta):
	if not control_enabled:
		return
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	submarine.movement_input = Vector3(input.x, 0, input.y).normalized()

	
