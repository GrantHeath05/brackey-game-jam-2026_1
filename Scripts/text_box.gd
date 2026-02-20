extends Control

@export var action_name := "Interact"  

func show_interact_prompt() -> void:
	var key = _get_first_key_for_action(action_name)
	$Label.text = "Press %s to interact" % key
	self.visible = true

func hide_interact_prompt() -> void:
	self.visible = false

func _get_first_key_for_action(key_name: String) -> String:
	var events = InputMap.action_get_events(key_name)
	for e in events:
		if e is InputEventKey:
			return OS.get_keycode_string(e.physical_keycode)
	return "Unknown"