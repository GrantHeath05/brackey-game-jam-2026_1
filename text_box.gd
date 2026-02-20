extends Control

func show_text(txt: String) -> void:
	$Panel/RichTextLabel.text = txt
	_continue_corner_label()
	self.visible = true


func _input(event: InputEvent) -> void:
	if not self.visible:
		return

	if event.is_action_pressed("Interact"):
		print_debug("Close text box")
		_hide_text()


func _hide_text():
	$Panel/RichTextLabel.text = ""
	self.visible = false


func _continue_corner_label():
	var interact_key = _get_first_key_for_action("Interact")
	$Panel/Label.text = "Press %s to continue" % interact_key

func _get_first_key_for_action(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	for e in events:
		if e is InputEventKey:
			return OS.get_keycode_string(e.physical_keycode)
	return "Unknown"
