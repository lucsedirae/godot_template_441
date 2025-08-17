# Unit testing base class
class_name Test
extends Node

func assert_count(actual, expected):
	if (actual == expected):
		print("Asserted actual equals expected\n")
		print("Actual: ", actual)
		print("Expected: ", expected)
	else:
		push_error("ERROR: Actual does not equal expected")
		print("Actual: ", actual)
		print("Expected: ", expected)
