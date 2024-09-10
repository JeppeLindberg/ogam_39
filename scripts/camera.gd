extends Node3D

@export var target: Node3D


var rotation_target: Vector3
var input_mouse: Vector2

var offset = Vector3(0, 2, -5)
var mouse_captured := true
var mouse_sensitivity = 700

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = global_position - target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_controls(delta)

	global_position = target.global_position + offset

	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)		
	rotation.x = lerp_angle(rotation.x, rotation_target.x, delta * 25)

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

		
func handle_controls(_delta):
	
	# Mouse capture
	
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		
		input_mouse = Vector2.ZERO