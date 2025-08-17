# TestRunner unit test
extends Test

@onready var TestRunner = preload("res://Util/tests/TestRunner.gd")

func _ready():
	var tests = TestRunner.get_tests()
	
