extends RigidBody3D

@onready var forward = get_node('forward')
@onready var rotation_pivot = get_node('/root/main/rotation_pivot')
@onready var velocity_direction = get_node('velocity_direction')
@onready var camera_forward = get_node('/root/main/camera/camera_forward')
@onready var camera_up = get_node('/root/main/camera/camera_up')
@onready var follow_up = get_node('follow_up')
@onready var up = get_node('up')

@export var max_velocity = 0.1
@export var max_torque = 0.1

@export var forward_acceleration_mult = 0.1
@export var follow_acceleration_mult = 0.1

var follow_up_offset = Vector3(0, 2, -5)
var follow_up_delta = Vector3(0, 2, -5)


func _ready() -> void:
	follow_up_delta = Vector3(follow_up.position.x, 0, 0)
	follow_up.position = Vector3(0, follow_up.position.y, follow_up.position.z)
	follow_up_offset = follow_up.position

func _process(_delta: float) -> void:	
	handle_controls(_delta)

func handle_controls(_delta):

	follow_up.position = follow_up_offset

	if Input.is_action_pressed("clockwise"):
		follow_up.position += follow_up_delta
	
	if Input.is_action_pressed("counter_clockwise"):
		follow_up.position -= follow_up_delta

func _physics_process(_delta):
	var forward_vec = forward.global_position - global_position;
	var camera_forward_vec = camera_forward.global_position - global_position;

	var forward_acceleration = rad_to_pct(linear_velocity.angle_to(forward_vec)) 
	var follow_acceleration = clamp(rad_to_pct(linear_velocity.angle_to(camera_forward_vec)) - forward_acceleration, 0, 1)

	var new_force = forward_vec * forward_acceleration * forward_acceleration_mult + camera_forward_vec * follow_acceleration * follow_acceleration_mult ;
	if (linear_velocity + new_force).length() > max_velocity:
		new_force = lerp((linear_velocity + new_force), (linear_velocity + new_force).normalized() * max_velocity, 0.1) - linear_velocity

	add_constant_force(new_force);

	var follow_up_vec = follow_up.global_position - global_position;
	
	rotation_pivot.global_position = global_position;
	# rotation_pivot.look_at(global_position + forward_vec, follow_up_vec)
	# var input_torque = rotate_toward_q(Quaternion(rotation_pivot.transform.basis), Quaternion(transform.basis), 0.1).get_euler()
	rotation_pivot.look_at(camera_forward.global_position, follow_up_vec, true)
	var camera_forward_torque = rotation_pivot.transform.basis.get_rotation_quaternion().get_euler() - transform.basis.get_rotation_quaternion().get_euler()
	# rotation_pivot.look_at(global_position + forward_vec, Vector3.UP)
	# var self_righting_torque = rotate_toward_q(Quaternion(rotation_pivot.transform.basis), Quaternion(transform.basis), 0.1).get_euler()
	
	var new_torque = camera_forward_torque - angular_velocity
	print(new_torque)
	# if (angular_velocity + new_torque).length() > max_torque:
	# 	new_torque = lerp((angular_velocity + new_torque), (angular_velocity + new_torque).normalized() * max_torque, 1) - angular_velocity

	add_constant_torque(new_torque)

func rotate_toward_q(from: Quaternion, to: Quaternion, angle: float) -> Quaternion:
	return from.slerp(to, angle)

func rad_to_pct_vec(rad: Vector3) -> Vector3:
	var res = Vector3(rad_to_pct(rad.x), rad_to_pct(rad.y), rad_to_pct(rad.z))
	return res

func rad_to_pct(rad: float) -> float:
	return rad / (2 * PI)
