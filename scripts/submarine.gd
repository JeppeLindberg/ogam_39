extends RigidBody3D


@export var movement_speed = 5.0
@export var damping_curve: Curve
@export var damping_min = 0.0
@export var damping_max = 1.0
@export var max_velocity = 10.0

var movement_input: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta):
	var sample = damping_curve.sample(min(linear_velocity.length() / max_velocity, 1))
	linear_damp = damping_min + (damping_max - damping_min) * sample

	constant_force = movement_input * movement_speed

# func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
