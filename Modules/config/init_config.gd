# init_config.gd
extends Node

const PATH_SAVEDATA: String = "res://Data/save_data/"
const SECTION_DEVTOOLS: String = "Devtools"
const SETTING_DEBUGGING: String = "Debugging"
const VALUE_STANDARD: String = "Standard"

var config = ConfigFile.new()

func _ready() -> void:
	print("Config manager loaded")
	

func set_default_config():
	config.set_value(SECTION_DEVTOOLS, SETTING_DEBUGGING, VALUE_STANDARD)
	config.save(PATH_SAVEDATA)
