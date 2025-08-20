# Unit testing base class
class_name Test
extends Node

func assert_equals(actual, expected):
	if (actual == expected):
		return true
	else:
		return false

func assert_false(actual):
	if actual == false:
		return true
	else:
		return false

func assert_true(actual):
	if actual == true:
		return true
	else:
		return false

func assert_empty(actual):
	if actual.is_empty():
		return true
	else:
		return false
