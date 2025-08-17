extends Node

const PATH_MODULES = "res://Modules/"
var TestRunner = preload("res://Util/tests/TestRunner.gd")

func _ready() -> void:
	var modules = get_modules(PATH_MODULES);
	TestRunner.run()
	

func get_modules(path: String) -> Array:
	var files = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("Failed to open directory: ", path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.begins_with("init_") and file_name.ends_with(".gd"):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return files
	
