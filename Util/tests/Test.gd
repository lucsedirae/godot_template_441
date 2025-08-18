# Unit testing base class
class_name Test
extends Node

func assert_equals(actual, expected):
	if (actual == expected):
		return true
	else:
		return false
