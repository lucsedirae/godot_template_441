# Modules/camera/CameraManager.gd
extends Node

var camera_dictionary: Dictionary = {}

func find_all_cameras():
	camera_dictionary.clear()
	_search_cameras_recursive(self)
	return camera_dictionary
	
func _search_cameras_recursive(node: Node):
	# Check if current node is a Camera3D
	if node is Camera3D:
		camera_dictionary[node.name] = node.name
	
	# Recursively search all children
	for child in node.get_children():
		_search_cameras_recursive(child)
