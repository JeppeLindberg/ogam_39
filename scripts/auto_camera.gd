extends Camera3D

@export var target: Node3D

var offset = Vector3(0, 2, -5)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = global_position - target.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = target.global_position + offset
