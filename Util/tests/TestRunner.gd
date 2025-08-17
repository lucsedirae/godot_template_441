extends Node

const PATH_TESTS = "res://Util/tests/"

static func run() -> void:
	var tests = get_tests(PATH_TESTS);
	print(tests)
	

static func get_tests(path = null) -> Array:
	path = path if path != null else PATH_TESTS
	
	var files = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("TestRunner failed to open directory: ", path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.begins_with("test_") and file_name.ends_with(".gd"):
			files.append(file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return files
