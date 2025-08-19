# ModuleManager
# res://Modules/ModuleManager.gd
class_name ModuleManager
extends Node

const PATH_MODULES = "res://Modules/"
static var modules_dict = null;

func _init() -> void:
	print("ModuleManager initialized...")
	modules_dict = get_modules_dict()

static func get_modules_dict() -> Dictionary:
	var filenames = get_module_filenames()
	var modules = {}
	for relative_path in filenames:
		var filename = relative_path.get_file()  # Get just the filename
		var module_name = filename.trim_prefix("init_").trim_suffix(".gd")
		var full_path = PATH_MODULES + module_name + "/" + relative_path
		modules[module_name] = full_path
	
	return modules

static func get_module_filenames(path: String = PATH_MODULES) -> Array:
	return _find_init_files(path)

static func _find_init_files(dir_path: String) -> Array:
	var dir = DirAccess.open(dir_path)
	if not dir: return []
	
	var files = []
	dir.list_dir_begin()
	var item = dir.get_next()
	
	while item:
		if not item in [".", ".."]:
			if item.begins_with("init_") and item.ends_with(".gd"):
				files.append(item)
			elif DirAccess.open(dir_path + "/" + item):  # Is directory
				files.append_array(_find_init_files(dir_path + "/" + item))
		item = dir.get_next()
	
	dir.list_dir_end()
	return files

func load_module(module_name: String) -> Node:
	# Ensure modules_dict is initialized
	if modules_dict == null:
		modules_dict = get_modules_dict()
	
	# Check if module exists
	if not modules_dict.has(module_name):
		push_error("Module not found: " + module_name)
		return null
	
	var module_path = modules_dict[module_name]
	
	# Load the script
	var script = load(module_path)
	if script == null:
		push_error("Failed to load module script: " + module_path)
		return null
	
	# Create an instance
	var instance = script.new()
	if instance == null:
		push_error("Failed to create instance of module: " + module_name)
		return null
	
	# Add as child if it's a Node
	if instance is Node:
		add_child(instance)
		instance.name = module_name + "_module"
		print("Module loaded and added: ", module_name)
	else:
		push_error("Module instance is not a Node: " + module_name)
		return null
	
	return instance
