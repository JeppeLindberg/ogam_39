extends Node3D


func get_beam_node(position_from, position_to):
	var ray_from = position_from
	var ray_to = position_to
	var space_state = get_world_3d().direct_space_state
	var ray = PhysicsRayQueryParameters3D.new()
	# ray.collision_mask = beam_collision_mask
	ray.from = ray_from
	ray.to = ray_to
	var collision = space_state.intersect_ray(ray)

	if collision.has('collider'):		
		return collision['collider']

	return null