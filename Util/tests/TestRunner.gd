extends Node

const PATH_TESTS = "res://Util/tests/"

# Run executes all tests
static func run() -> void:
	print("Initializing tests...")
	var tests = load_tests()
	
	for test in tests:
		test.run()

# Get test files and instantiates each as a test
static func load_tests() -> Array:
	var test_files = get_filenames(PATH_TESTS)
	var instances = []
	
	for filename in test_files:
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
	
	return instances

# Get filenames of tests in test path
static func get_filenames(path = null) -> Array:
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
