# Modules/scenes/SceneManager.gd
extends Node

## Base path where scene files are stored
const PATH_SCENES: String = "res://Scenes/"

## Suffix added to scene instance names when loaded
const SUFFIX_SCENE: String = "_scene"

## Name of the currently loaded scene
var current = null

var local_debugging: bool = false

## Dictionary mapping scene names to their file paths
var scenes_dict: Dictionary

## Initializes the scene manager
##
## Logs initialization message for debugging purposes
func _ready() -> void:
	Debug.print_message("Scene manager loaded", local_debugging)

## Adds a packed scene to the current scene or a provided target node
##
## @param scene_name Name of the scene to load (without file extension)
## @param parent_node Optional parent node to add the scene to (defaults to current scene)
## @return The instantiated scene node, or null if loading failed
func load_scene(scene_name: String, parent_node: Node = null) -> Node:
	if !scenes_dict:
		scenes_dict = get_scenes_dict()
	
	# Validate scene exists
	if not scenes_dict.has(scene_name):
		push_error("Scene not found: " + scene_name)
		return null
	
	# Load and instantiate
	var scene_path = scenes_dict[scene_name]
	var scene_resource = load(scene_path)
	if not scene_resource:
		push_error("Failed to load scene: " + scene_path)
		return null
	
	var instance = scene_resource.instantiate()
	if not instance:
		push_error("Failed to instantiate scene: " + scene_name)
		return null
	
	# Add to scene tree
	(parent_node if parent_node else get_tree().current_scene).add_child(instance)
	instance.name = scene_name + SUFFIX_SCENE
	current = scene_name
	
	Debug.print_message(["Scene loaded: ", scene_name], local_debugging)
	return instance

## Gets scenes from the scenes directory and adds them to the scenes dictionary
##
## @return Dictionary mapping scene names to their absolute file paths
func get_scenes_dict() -> Dictionary:
	var filenames = get_scene_filenames()
	var scenes = {}
	
	for relative_path in filenames:
		var filename = relative_path.get_file()
		var scene_name_base = filename.trim_suffix(Lib.FILE_EXT_TSCN)
		var full_path = PATH_SCENES + relative_path
		
		var scene_name: String
		if relative_path.contains("/"):
			# Use directory structure for naming: "DumpTruck_dumptruck"
			var directory = relative_path.get_base_dir().replace("/", "_")
			scene_name = directory + "_" + scene_name_base
		else:
			# Scene is in root directory
			scene_name = scene_name_base
		
		scenes[scene_name] = full_path
		Debug.print_message(["Registered scene: " + scene_name + " -> " + full_path], local_debugging)
	
	return scenes

## Get all scene filenames with recursive directory support
##
## @return Array of relative file paths for all .tscn files found
func get_scene_filenames() -> Array:
	return get_scene_filenames_recursive("", PATH_SCENES)

## Recursive helper function to search for .tscn files
##
## @param relative_path Current relative path being processed
## @param absolute_path Current absolute directory path being searched
## @return Array of relative file paths for .tscn files in this directory and subdirectories
func get_scene_filenames_recursive(relative_path: String, absolute_path: String) -> Array:
	var dir = DirAccess.open(absolute_path)
	if not dir: 
		Debug.print_message(["Failed to open directory: ", absolute_path], local_debugging)
		return []
	
	var files = []
	dir.list_dir_begin()
	var item = dir.get_next()
	
	while item:
		# Skip system filesystem entries
		if item in [".", ".."]:
			item = dir.get_next()
			continue
		
		var item_absolute_path = absolute_path + "/" + item
		var item_relative_path = relative_path + ("/" if relative_path != "" else "") + item
		
		# Check if it's a directory
		if dir.current_is_dir():
			Debug.print_message(["Searching subdirectory: ", item_relative_path], local_debugging)
			# Recursively search the subdirectory
			var subdirectory_files = get_scene_filenames_recursive(item_relative_path, item_absolute_path)
			files.append_array(subdirectory_files)
		elif item.ends_with(Lib.FILE_EXT_TSCN):
			files.append(item_relative_path)
			Debug.print_message(["Found scene file: ", item_relative_path], local_debugging)
		
		item = dir.get_next()
	
	dir.list_dir_end()
	return files

## Get the name of the currently loaded scene
##
## @return The current scene name as a string, or null if no scene is loaded
func get_current() -> Variant:
	if current != null and current != "":
		return current
	return null
