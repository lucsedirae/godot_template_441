extends Node

var TestRunner = preload("res://Util/tests/TestRunner.gd")

func _ready() -> void:
	TestRunner.run()
