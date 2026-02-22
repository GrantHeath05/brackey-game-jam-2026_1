extends Node2D

var voice_line = "There are three elements you can find in nature that create everything, Rock, Paper, and Scissors or something like that at least."
var monster_type = "RPS"

var player_in_range := false
var waiting_for_prompt_close := false
var textbox_open := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not visible:
		return
	if body.is_in_group("Player"):
		player_in_range = true

		# Small prompt (NO arguments)
		$Control.show_interact_prompt()
		waiting_for_prompt_close = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		waiting_for_prompt_close = false
		textbox_open = false

		$Control.hide_interact_prompt()
		GameManager.hide_textbox()

func _process(_delta):
	$Indicator.visible = not GameManager.RPS_complete
	if not visible:
		return
	if not player_in_range:
		return

	# STEP 1: Close the small prompt
	if waiting_for_prompt_close:
		if Input.is_action_just_pressed("Interact"):
			$Control.hide_interact_prompt()
			waiting_for_prompt_close = false

			GameManager.show_textbox(voice_line, monster_type)
			textbox_open = true
		return

	# STEP 2: Close textbox and start game
	if textbox_open:
		if Input.is_action_just_pressed("Interact"):
			GameManager.hide_textbox()
			textbox_open = false
			GameManager.show_RPS()
		return
