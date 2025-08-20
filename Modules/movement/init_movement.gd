extends Node

func _ready() -> void:
	print("Movement module loaded")

static func setup_wasd_controls():
	var movement_actions = {
		"move_up": KEY_W,
		"move_left": KEY_A,
		"move_down": KEY_S,
		"move_right": KEY_D
	}
	
	# Add each action and bind the corresponding key
	for action_name in movement_actions.keys():
		var key_code = movement_actions[action_name]
		
		# Check if action already exists, if not create it
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			print("Added action: ", action_name)
		else:
			print("Action already exists: ", action_name)
		
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
			print("Mapped ", OS.get_keycode_string(key_code), " to ", action_name)
		else:
			print("Key ", OS.get_keycode_string(key_code), " already mapped to ", action_name)
