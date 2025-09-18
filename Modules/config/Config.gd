# Modules/config/Config.gd
extends Node

## Path to the settings configuration file
const PATH_SETTINGS: String = "res://Modules/config/settings.json"

## Setting key identifier for the debug mode toggle option
const SETTING_TOGGLE_DEBUG: String = "setting_toggle_debug"

## Setting key identifier for the exit/quit application option
const SETTING_EXIT: String = "setting_exit"

## UI element type constant for checkbox controls
const TYPE_CHECKBOX: String = "checkbox"

## UI element type constant for button controls
const TYPE_BUTTON: String = "button"

var local_debugging: bool = false
var settings_data: Dictionary = {}

## Initializes the configuration manager
func _ready() -> void:
	load_settings()

## Get a setting value
##
## @param key The setting key to retrieve
## @param default_value Value to return if key doesn't exist
## @return The setting value, or default_value if key not found
func get_setting(key: String, default_value = null) -> Variant:
	return settings_data.get(key, default_value)

## Set a setting value
##
## @param key The setting key to update
## @param value The new value to store
## @return True if setting was updated successfully, false if key doesn't exist
func set_setting(key: String, value) -> bool:
	if key in settings_data:
		settings_data[key] = value
		save_settings()
		return true
	else:
		Debug.print_message(["Warning: Attempted to set non-existent key: ", key], local_debugging)
		return false

## Check if a setting exists
##
## @param key The setting key to check
## @return True if the setting exists, false otherwise
func has_setting(key: String) -> bool:
	return key in settings_data

## Save settings to JSON file
func save_settings() -> void:
	var file = FileAccess.open(PATH_SETTINGS, FileAccess.WRITE)
	
	if file == null:
		Debug.print_message(["Error: Could not open settings file for writing: ", PATH_SETTINGS], local_debugging)
		return
	
	var json_string = JSON.stringify(settings_data, "\t")
	file.store_string(json_string)
	file.close()

## Load settings from JSON file
##
## Reads and parses the settings file, populating the settings_data dictionary
func load_settings() -> void:
	if not FileAccess.file_exists(PATH_SETTINGS):
		Debug.print_message(["Settings file doesn't exist yet: ", PATH_SETTINGS], local_debugging)
		return
	
	var file = FileAccess.open(PATH_SETTINGS, FileAccess.READ)
	if file == null:
		Debug.print_message(["Error: Could not open settings file for reading: ", PATH_SETTINGS], local_debugging)
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	if json.parse(json_string) != OK:
		push_error("Error parsing settings JSON: " + json.get_error_message())
		return
	
	var parsed_data = json.get_data()
	if typeof(parsed_data) == TYPE_DICTIONARY:
		settings_data = parsed_data
	else:
		push_error("Error: Settings file contains invalid data format")

## Reset settings to default
func reset_settings() -> void:
	settings_data.clear()
	save_settings()

## Get all settings (useful for debugging)
##
## @return A duplicate of the settings_data dictionary
func get_all_settings() -> Dictionary:
	return settings_data.duplicate()

## Remove a specific setting
##
## @param key The setting key to remove
## @return True if setting was removed successfully, false if key didn't exist
func remove_setting(key: String) -> bool:
	if key in settings_data:
		settings_data.erase(key)
		save_settings()
		return true
	return false

## Exit the game
##
## @param debug Bool: display the 'exit button pressed' debug message?
func exit(debug: bool = false) -> void:
	Debug.print_message("Exit button pressed", debug)
	get_tree().quit()
