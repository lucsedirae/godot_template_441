# TestRunner unit test
extends Test

var TestRunner = preload("res://Util/tests/TestRunner.gd")
var filename = "test_TestRunner.gd"

const TEST_COUNT = 2

# Run test
func run():
	print("\nInitializing test: ", filename)
	test_get_filenames()

# Checks number of files in test directory
func test_get_filenames():
	print("\ntest_get_filenames:")
	var files = TestRunner.get_filenames()
	var passing = super.assert_equals(files.size(), TEST_COUNT)
	if passing:
		print("Asserted actual test file count equals expected")
		print("Passed!")
	else:
		push_error("\nERROR: Actual test file count does not equal expected")
		print("Failed!")
