extends RigidBody3D


@export var movement_speed = 5.0
@export var damping_curve: Curve
@export var damping_min = 0.0
@export var damping_max = 1.0
@export var max_velocity = 10.0

@onready var beam_emitter = get_node('beam_emitter')
@onready var player_camera = get_node('/root/main/player/Head/Camera')

var movement_input: Vector3

var control_enabled := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta):
	if not control_enabled:
		return

	beam_emitter.global_rotation = player_camera.global_rotation
	beam_emitter.rotation_degrees = Vector3(
		clamp(beam_emitter.rotation_degrees.x, -45, 45),
		clamp(beam_emitter.rotation_degrees.y, -45, 45),
		clamp(beam_emitter.rotation_degrees.z, -45, 45)
	)

func _physics_process(_delta):
	_physics_handle_controls(_delta)

	var sample = damping_curve.sample(min(linear_velocity.length() / max_velocity, 1))
	linear_damp = damping_min + (damping_max - damping_min) * sample

	constant_force = movement_input * movement_speed

func _physics_handle_controls(_delta):
	if not control_enabled:
		return
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	movement_input = Vector3(input.x, 0, input.y).normalized()
