# /Util/debug/Debug.gd
extends Node

var _private_messaging_is_on: bool = true

## Reports on debug state
func is_debug_on() -> bool:
	return _private_messaging_is_on

## Handle debugging state
func set_debug(state: bool) -> void:
	if _private_messaging_is_on != state:
		_private_messaging_is_on = state
		print("Debug set to: ", state)
	else:
		push_error("Debug messaging is already set to " + str(_private_messaging_is_on))

## Prints debug messages if debugging is enabled.
## Local debugging is assumed to be true but is typically passed as false by default so that
## scripts can implement debugging without cluttering up the console
func print_message(params, local: bool = true) -> void:
	if _private_messaging_is_on && local:
		match typeof(params):
			TYPE_STRING, TYPE_ARRAY:
				print(params)
			_:
				push_error("Expected String or Array. Got: " + str(typeof(params)))
