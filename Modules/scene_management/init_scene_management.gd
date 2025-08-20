extends Node

const PATH_SCENES = "res://Scenes/"
var scenes_dict = null
var current = null

func _ready() -> void:
	print("Scene manager loaded")

func load_scene(scene_name: String, parent_node: Node = null) -> Node:
	# Ensure scenes_dict is initialized
	if scenes_dict == null:
		scenes_dict = get_scenes_dict()
	
	print("Available scenes: ", scenes_dict.keys())
	print("Looking for scene: ", scene_name)
	
	# Check if scene exists
	if not scenes_dict.has(scene_name):
		push_error("Scene not found: " + scene_name)
		return null
	
	var scene_path = scenes_dict[scene_name]
	print("Loading scene from path: ", scene_path)
	
	# Load the scene (not script!)
	var scene_resource = load(scene_path)
	if scene_resource == null:
		push_error("Failed to load scene: " + scene_path)
		return null
	
	# Create an instance using instantiate() instead of new()
	var instance = scene_resource.instantiate()
	if instance == null:
		push_error("Failed to instantiate scene: " + scene_name)
		return null
	
	# Add as child if it's a Node (scenes are always Nodes)
	var target_parent = parent_node if parent_node != null else get_tree().current_scene
	target_parent.add_child(instance)
	instance.name = scene_name + "_scene"
	print("Scene loaded and added: ", scene_name)
	
	current = scene_name
	
	return instance

func get_scenes_dict() -> Dictionary:
	var filenames = get_scene_filenames()
	var scenes = {}
	
	for relative_path in filenames:
		var filename = relative_path.get_file()  # Get just the filename
		var scene_name = filename.trim_suffix(".tscn")
		var full_path = PATH_SCENES + relative_path  # Just concatenate directly
		scenes[scene_name] = full_path
	
	return scenes

func get_scene_filenames():
	var dir = DirAccess.open(PATH_SCENES)
	if not dir: return []
	
	var files = []
	dir.list_dir_begin()
	var item = dir.get_next()
	
	#TODO: support recursive search for subdirs
	while item:
		# Filter out system filesystem entries...
		if not item in [".", ".."]:
			if item.ends_with(".tscn"):
				files.append(item)
		item = dir.get_next()
	
	dir.list_dir_end()
	return files

func get_current() -> Variant:
	if current != null and current != "":
		return current
	return null
