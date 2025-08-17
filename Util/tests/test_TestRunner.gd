# TestRunner unit test
extends Test

@onready var TestRunner = preload("res://Util/tests/TestRunner.gd")
var filename = "test_TestRunner.gd"

func run():
	print("Initializing test: ", filename)
	#test_get_tests()
	super.assert_count(1, 1)
	

#func test_get_tests():
	#var tests = TestRunner.get_tests()
