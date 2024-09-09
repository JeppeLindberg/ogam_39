extends RigidBody3D

@onready var forward = get_node('forward')
@onready var up = get_node('up')
@onready var velocity_direction = get_node('velocity_direction')

@export var self_righting_torque = 10.0
@export var self_righting_torque_max = 0.2
@export var angular_damp_mult = 0.1
@export var angular_damp_curve: Curve

func _physics_process(_delta):
	var up_vec = global_position - up.global_position;
	var forward_vec = global_position - forward.global_position;

	if linear_velocity.length() > 0.01:
		velocity_direction.look_at(global_position + linear_velocity, up_vec)

	var velocity_to_forward_angle = rad_to_deg(linear_velocity.angle_to(forward_vec))
	var res = rotate_toward_q(Quaternion(velocity_direction.basis), Quaternion(forward.basis), velocity_to_forward_angle)
	print(res.get_axis())

	var self_righting_torque_vec = res.get_axis() * clamp(self_righting_torque * linear_velocity.length(), 0, self_righting_torque_max);

	angular_damp = angular_damp_mult * angular_damp_curve.sample(inverse_lerp(0, 180, velocity_to_forward_angle))

	add_constant_torque(self_righting_torque_vec);


func rotate_toward_q(from: Quaternion, to: Quaternion, angle: float) -> Quaternion:
	return from.slerp(to, angle)

