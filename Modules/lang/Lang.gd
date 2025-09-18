# Modules/lang/Lang.gd
extends Node

const PATH_FALLBACK: String = "res://localization/"
const PATH_LOCALIZATION: String = "res://Modules/lang/localization/"
const LANG_DEFAULT: String = "en"

@export var local_debugging: bool = false

## Dictionary containing all loaded translations for the current language
var translations: Dictionary = {}

## Language code to use when translations are missing in the current language
var fallback_language: String = "en"

## Currently active language code
var current_language: String

## Available languages mapping language codes to display names
var available_languages: Dictionary = {
	"en": "English",
	#"es": "Spanish", 
	#"fr": "French",
	#"jp": "Japanese",
}

## Signal emitted when language changes
##
## @param new_language The language code that was just loaded
signal language_changed(new_language: String)

## Initializes the localization system
##
## Loads the default language on startup
func _ready() -> void:
	load_language(LANG_DEFAULT)

## Load a language file and set it as the current language
##
## @param language_code The language code to load (e.g., "en", "es", "fr")
## @return True if language loaded successfully, false if file not found or invalid
func load_language(language_code: String) -> bool:
	var file_path = PATH_LOCALIZATION + language_code + ".json"
	
	Debug.print_message(["File path: ", file_path], local_debugging)
	
	if not FileAccess.file_exists(file_path):
		push_error("Translation file not found: " + file_path)
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Could not open translation file: " + file_path)
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Error parsing JSON in " + file_path)
		return false
	
	translations = json.data
	current_language = language_code
	
	# Emit signal for UI updates
	language_changed.emit(language_code)
	return true

## Main translation function with placeholder support
##
## @param key The translation key to look up
## @param placeholders Dictionary of placeholder replacements (e.g., {player_name})
## @return Translated text with placeholders replaced, or the key if translation not found
func translate(key: String, placeholders: Dictionary = {}) -> String:
	var text = get_translation(key)
	
	# Replace placeholders like {player_name}, {score}, etc.
	for placeholder in placeholders:
		text = text.replace("{" + placeholder + "}", str(placeholders[placeholder]))
	
	return text

## Get translation with fallback support
##
## @param key The translation key to retrieve
## @return The translated text, fallback translation, or the key itself if no translation found
func get_translation(key: String) -> String:
	# Try current language first
	if translations.has(key):
		return translations[key]
	
	# Try fallback language if current fails
	if current_language != fallback_language:
		if load_fallback_translation(key):
			return translations.get(key, key)
	
	# Return key if no translation found
	push_warning("Translation missing for key: " + key)
	return key

## Load a specific translation from the fallback language file
##
## @param key The translation key to load from fallback
## @return True if fallback translation was found and loaded, false otherwise
func load_fallback_translation(key: String) -> bool:
	var fallback_path = PATH_FALLBACK + fallback_language + ".json"
	
	if not FileAccess.file_exists(fallback_path):
		return false
	
	var file = FileAccess.open(fallback_path, FileAccess.READ)
	if not file:
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	if json.parse(json_string) != OK:
		return false
	
	var fallback_translations = json.data
	if fallback_translations.has(key):
		translations[key] = fallback_translations[key]
		return true
	
	return false

## Set new language and reload translations
##
## @param language_code The language code to switch to
func set_language(language_code: String) -> void:
	if language_code != current_language:
		load_language(language_code)

## Get the currently active language code
##
## @return The current language code (e.g., "en", "es", "fr")
func get_current_language() -> String:
	return current_language

## Get all available languages
##
## @return Dictionary mapping language codes to display names
func get_available_languages() -> Dictionary:
	return available_languages
