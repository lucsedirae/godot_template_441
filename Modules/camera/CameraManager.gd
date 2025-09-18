# Modules/camera/CameraManager.gd
extends Node

var camera_dictionary: Dictionary
var current: Camera3D
var local_debugging: bool = false

## Finds all cameras in the parent node
##
## @param node The parent node. Typically init node
func find_all_cameras(node: Node):
	camera_dictionary.clear()
	search_cameras_recursive(node)

## Finds all camera in node tree
##
## @param node The parent node. Typically init node
func search_cameras_recursive(node: Node):
	if node is Camera3D:
		camera_dictionary[str(node.name)] = node
		if node.current:
			current = node
	
	for child in node.get_children():
		search_cameras_recursive(child)

## Sets the current camera to the node name provided
##
## @param key Node name of the Camera3D node to be set as current
func set_current(key: String):
	var camera: Camera3D = camera_dictionary[key]
	if !camera:
		push_error("No camera found with the name:", key)
	
	current.current = false
	camera.current = true
	current = camera  # Update the current reference
	Debug.print_message(["Current camera changed to:", str(current.name)], local_debugging)

## Finds the current camera and sets the next camera current
func cycle_next_camera()-> void:
	if camera_dictionary.is_empty() or current == null:
		return
	
	# Get all camera keys as an array
	var keys = camera_dictionary.keys()
	var current_key = str(current.name)
	var current_index = keys.find(current_key)
	
	# Handle case where current camera isn't found in dictionary
	if current_index == -1:
		set_current(keys[0])
		return
	
	# Get next index with wraparound to first camera
	var next_index = (current_index + 1) % keys.size()
	set_current(keys[next_index])
