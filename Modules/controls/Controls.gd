# Modules/controls/Controls.gd
extends Node

@export var local_debugging: bool = false

## Dictionary mapping action names to their corresponding key codes
var movement_actions = {
		"move_up": KEY_W,
		"move_left": KEY_A,
		"move_down": KEY_S,
		"move_right": KEY_D,
		"ui_accept": KEY_SPACE,
		"ui_main_menu": KEY_ESCAPE,
		"dev_f1": KEY_F1,
	}

## Maps input controls to the Godot InputMap programmatically
func init_controls() -> void:
	for action_name in movement_actions.keys():
		var key_code = movement_actions[action_name]
		
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			Debug.print_message(["Added action: ", action_name], local_debugging)
		else:
			Debug.print_message(["Action already exists: ", action_name], local_debugging)
		
		# Create the key input event
		var key_event = InputEventKey.new()
		key_event.keycode = key_code
		
		# Check if this specific key is already mapped to this action
		var already_mapped = false
		for existing_event in InputMap.action_get_events(action_name):
			if existing_event is InputEventKey and existing_event.keycode == key_code:
				already_mapped = true
				break
		
		# Add the key event to the action if not already mapped
		if not already_mapped:
			InputMap.action_add_event(action_name, key_event)
			Debug.print_message(["Mapped ", OS.get_keycode_string(key_code), " to ", action_name], local_debugging)
		else:
			Debug.print_message(["Key ", OS.get_keycode_string(key_code), " already mapped to ", action_name], local_debugging)

## Get the current input direction vector
##
## @return Vector2 representing input direction (-1 to 1 on both axes)
func get_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
