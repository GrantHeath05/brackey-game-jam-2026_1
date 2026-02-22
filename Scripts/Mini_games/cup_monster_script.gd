extends Node2D

var voice_line = ". . pick. pick cup."
var monster_type = "Cup"
var player_in_range := false
var textbox_open := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if not visible:
		return
	if body.is_in_group("Player"):
		player_in_range = true
		$Control.show_interact_prompt()   # small prompt above monster

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		textbox_open = false
		$Control.hide_interact_prompt()

		# Run function here e.g.
		# GameManager.hide_textbox()
		GameManager.hide_textbox()

func _process(_delta):
	$Indicator.visible = not GameManager.guess_cup_complete
	if not visible:
		return
	if not player_in_range:
		return

	# If textbox is open, Interact should close it and start the game
	if textbox_open:
		if Input.is_action_just_pressed("Interact"):

			# Run function here e.g.
			# GameManager.hide_textbox()
			GameManager.hide_textbox()

			textbox_open = false

			# Run function here e.g.
			# GameManager.show_cup_game()
			GameManager.show_cup_game()

		return

	# If textbox is NOT open, Interact should open it
	if Input.is_action_just_pressed("Interact"):
		$Control.hide_interact_prompt()   # hide small prompt

		# Run function here e.g.
		# GameManager.show_textbox("test", "Cup")
		GameManager.show_textbox(voice_line, "Cup")

		textbox_open = true
	else:
		$Control.show_interact_prompt()
