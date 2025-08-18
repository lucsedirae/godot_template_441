# TestRunner unit test
extends Test

var TestRunner = preload("res://Util/tests/TestRunner.gd")
var filename = "test_TestRunner.gd"

const TEST_COUNT = 1

func run():
	print("Initializing test: ", filename)
	test_get_filenames()

# Checks number of files in test directory
func test_get_filenames():
	var files = TestRunner.get_filenames()
	var passing = super.assert_equals(files.size(), TEST_COUNT)
	if passing:
		print("Asserted actual test file count equals expected\n")
		print("Passed!")
	else:
		push_error("ERROR: Actual test file count does not equal expected")
		print("Failed!")
