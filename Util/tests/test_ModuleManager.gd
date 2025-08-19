# TestRunner unit test
extends Test

var ModuleManager = preload("res://Modules/ModuleManager.gd")
var filename = "test_ModuleManager.gd"

const MODULE_COUNT = 6

# Run test
func run():
	print("\nInitializing test: ", filename)
	test_get_module_filenames()

func test_get_module_filenames():
	print("test_get_module_filenames:")
	var files = ModuleManager.get_module_filenames()
	var passing = super.assert_equals(files.size(), MODULE_COUNT)
	if passing:
		print("\nAsserted actual test file count equals expected")
		print("Passed!")
	else:
		push_error("\nERROR: Actual test file count does not equal expected")
		print("Failed!")
