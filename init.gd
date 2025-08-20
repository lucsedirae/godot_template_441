extends Node
var TestRunner = preload("res://Util/tests/TestRunner.gd")
var ModuleManagerClass = preload("res://Modules/ModuleManager.gd")

func _ready() -> void:
	TestRunner.run()
	var module_manager = ModuleManagerClass.new()
	
	# Load modules required for game initialization - pass 'self' as parent
	var config_module = module_manager.load_module("config", self)
	var ui_module = module_manager.load_module("ui", self)
	var scene_manager = module_manager.load_module("scene_management", self)
	var movement_module = module_manager.load_module("movement", self)

	movement_module.setup_wasd_controls()
	scene_manager.load_scene("main")
