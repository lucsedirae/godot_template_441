# ModuleManager
# res://Modules/ModuleManager.gd
extends Node

const PATH_MODULES = "res://Modules/"

func _ready() -> void:
	var modules = get_module_filenames()

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
