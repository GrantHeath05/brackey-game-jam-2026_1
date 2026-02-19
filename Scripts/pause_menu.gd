extends Control


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()

func resume():
	get_tree().paused = false
	self.visible = false
	$Volume.visible = false
	$PauseMenu.visible = false
	$InputSettings.visible = false



func pause():
	print_debug("Game is paused")
	get_tree().paused = true
	# await $AnimationPlayer.play("Show_Menu")
	self.visible = true
	$PauseMenu.visible = true
	$InputSettings.visible = false


func _on_resume_pressed():
	resume()

func _on_quit_to_desktop_pressed():
	get_tree().quit()
	print_debug("Quit ran but game is not an application")

func edit_objective_txt(text: String):
	# might add \n before objective text to add a gap
	$PauseMenu/VBoxContainer/ObjectiveLabel.text = ""
	$PauseMenu/VBoxContainer/ObjectiveLabel.text = "Objective: "
	$PauseMenu/VBoxContainer/ObjectiveLabel.text += text

func _on_settings_pressed():
	$Volume.visible = true
	$PauseMenu.visible = false
	$InputSettings.visible = false

func _on_leave_settings_pressed():
	$Volume.visible = false
	$PauseMenu.visible = true
	$InputSettings.visible = false


func _on_un_stuck_pressed() -> void:
	if GameManager.Player:
		GameManager.Player.global_position = Vector2(0, 0)


func _on_controls_settings_pressed() -> void:
	$Volume.visible = false
	$PauseMenu.visible = false
	$InputSettings.visible = true


func _on_close_control_remapper_pressed() -> void:
	$Volume.visible = false
	$PauseMenu.visible = true
	$InputSettings.visible = false
