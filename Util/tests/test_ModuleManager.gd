# TestRunner unit test
extends Test

var ModuleManager = preload("res://Modules/ModuleManager.gd")
var module_manager = null
var filename = "test_ModuleManager.gd"


const MODULE_COUNT = 6

func _init() -> void:
	module_manager = ModuleManager.new()

# Run test
func run():
	print("\nInitializing test: ", filename)
	test_get_module_filenames()
	test_load_module()

func test_get_module_filenames():
	print("\ntest_get_module_filenames:")
	var files = module_manager.get_module_filenames()
	var passing = super.assert_equals(files.size(), MODULE_COUNT)
	if passing:
		print("Asserted actual test file count equals expected")
		print("Passed!")
	else:
		push_error("\nERROR: Actual test file count does not equal expected")
		print("Failed!")

func test_load_module():
	print("\ntest_load_module:")
