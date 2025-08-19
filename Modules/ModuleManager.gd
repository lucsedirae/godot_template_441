# ModuleManager
# res://Modules/ModuleManager.gd
extends Node

const PATH_MODULES = "res://Modules/"

func _ready() -> void:
	var modules_dict = get_modules_dict()

static func debug():
	var modules_dict = get_modules_dict()

static func get_modules_dict() -> Dictionary:
	var filenames = get_module_filenames()
	var modules = {}
	
	for relative_path in filenames:
		var filename = relative_path.get_file()  # Get just the filename
		var module_name = filename.trim_prefix("init_").trim_suffix(".gd")
		var full_path = PATH_MODULES + relative_path
		modules[module_name] = full_path
	
	print(modules)
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
