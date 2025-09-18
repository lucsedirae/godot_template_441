# Modules/lib.gd
extends Node

const FILE_EXT_TRES: String = ".tres"
const FILE_EXT_TSCN: String = ".tscn"
const NODE_BUTTON: String = "Button"

var local_debugging: bool = false

## Determine if an object is garbage
func is_garbage_object(body: RigidBody3D) -> bool:
	if body.has_method("get") and "is_garbage_object" in body:
		return body.is_garbage_object
	return false

## Lock a 3D node's axes to prevent tipping
func prevent_tipover(node: Node3D) -> void:
	node.axis_lock_angular_x = true  # Lock tilting forward/back
	node.axis_lock_angular_z = true  # Lock rolling left/right
	node.axis_lock_angular_y = false # Allow turning left/right

## Load all resources from a specified path
func load_tres_files_from_path(path: String) -> Dictionary:
	var tres_dict = {}
	var dir = DirAccess.open(path)
	
	if dir == null:
		push_error("Failed to open directory: ", path)
		return tres_dict
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(FILE_EXT_TRES):
			var full_path = path + "/" + file_name
			var resource = load(full_path)
			
			if resource != null:
				# Use filename without extension as key
				var key = file_name.get_basename()
				tres_dict[key] = resource
				Debug.print_message(["Loaded: ", file_name], local_debugging)
			else:
				push_error("Failed to load: ", file_name)
		
		file_name = dir.get_next()
		
	Debug.print_message(["Loaded ", tres_dict.size(), " .tres files from ", path], local_debugging)
	return tres_dict

## Checks if a given node is touching the ground using raycasting
##
## @param node The Node3D to check ground contact for
## @param check_distance How far down to raycast for ground detection (default: 1.1)
## @return bool True if the node is grounded, false otherwise
func check_ground(node: Node3D, check_distance: float = 1.1) -> bool:
	var space_state = node.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		node.global_position,
		node.global_position + Vector3(0, -check_distance, 0)
	)
	query.exclude = [node]  # Don't hit the node we're checking
	
	var result = space_state.intersect_ray(query)
	return result.has("collider")
