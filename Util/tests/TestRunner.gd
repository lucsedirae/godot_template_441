extends Node

const PATH_TESTS = "res://Util/tests/"

static func run() -> void:
	var test_files = get_tests(PATH_TESTS)
	var test_instances = instantiate_tests(test_files)
	
	# Run tests on each instance
	for test_instance in test_instances:
		run_test_methods(test_instance)

static func instantiate_tests(test_filenames: Array) -> Array:
	var instances = []
	
	for filename in test_filenames:
		var full_path = PATH_TESTS + filename
		
		# Load the script
		var script = load(full_path)
		if script == null:
			print("Failed to load script: ", full_path)
			continue
		
		# Create an instance
		var instance = script.new()
		if instance == null:
			print("Failed to instantiate: ", full_path)
			continue
		
		instances.append(instance)
		print("Instantiated test: ", filename)
	
	return instances

static func run_test_methods(test_instance) -> void:
	# Get all methods from the test instance
	var methods = test_instance.get_method_list()
	
	# Run methods that start with "test_"
	for method_info in methods:
		var method_name = method_info["name"]
		if method_name.begins_with("test_"):
			print("Running test method: ", method_name)
			test_instance.call(method_name)

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
