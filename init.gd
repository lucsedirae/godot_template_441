extends Node

var TestRunner = preload("res://Util/tests/TestRunner.gd")
var ModuleManager = preload("res://Modules/ModuleManager.gd")

func _ready() -> void:
	TestRunner.run()
	var module_manager = ModuleManager.new()
	
	# Load modules required for game initialization
	var config_module = module_manager.load_module("config")
	if config_module is Node:
		print('SUCCESS')
	else:
		print('FAIL')
