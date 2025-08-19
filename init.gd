extends Node

var TestRunner = preload("res://Util/tests/TestRunner.gd")
var ModuleManager = preload("res://Modules/ModuleManager.gd")

func _ready() -> void:
	TestRunner.run()
	ModuleManager.debug()
