extends Control

enum Move { ROCK, PAPER, SCISSORS }

var input_enabled := false
var icons := {}
var last_result := ""   # <-- track win/lose/tie

@export var choices: HBoxContainer
@export var player_display: TextureRect
@export var cpu_display: TextureRect
@export var results_label: Label
@export var try_again_btn: Button

@export var rock_button: TextureButton
@export var paper_button: TextureButton
@export var scissors_button: TextureButton

@export var blank_icon: Texture2D   # <-- assign blank frame here


func _ready():
	icons = {
		Move.ROCK: rock_button.texture_normal,
		Move.PAPER: paper_button.texture_normal,
		Move.SCISSORS: scissors_button.texture_normal
	}

	rock_button.pressed.connect(func(): _on_player_choice(Move.ROCK, rock_button))
	paper_button.pressed.connect(func(): _on_player_choice(Move.PAPER, paper_button))
	scissors_button.pressed.connect(func(): _on_player_choice(Move.SCISSORS, scissors_button))

	try_again_btn.pressed.connect(_on_try_again_pressed)

	start_game()


func start_game():
	input_enabled = true

	for b in choices.get_children():
		b.visible = true
		b.disabled = false

	# Always show blank frame when no choice is made
	player_display.texture = blank_icon
	cpu_display.texture = blank_icon

	results_label.text = ""
	try_again_btn.visible = false
	last_result = ""


func _on_player_choice(player_move: Move, button: TextureButton):
	if not input_enabled:
		return

	input_enabled = false

	button.visible = false
	player_display.texture = icons[player_move]

	await get_tree().create_timer(0.6).timeout

	_cpu_turn(player_move)


func _cpu_turn(player_move: Move):
	var cpu_move = Move.values().pick_random()
	cpu_display.texture = icons[cpu_move]

	last_result = _determine_winner(player_move, cpu_move)

	match last_result:
		"win":
			results_label.text = "Winner"
			try_again_btn.text = "Exit"      # <-- exit mode
			try_again_btn.visible = true

		"lose":
			results_label.text = "Loser"
			try_again_btn.text = "Try Again" # <-- retry mode
			try_again_btn.visible = true

		"tie":
			results_label.text = "Tie"
			try_again_btn.text = "Try Again" # <-- retry mode
			try_again_btn.visible = true


func _determine_winner(player: Move, cpu: Move) -> String:
	if player == cpu:
		return "tie"

	if (player == Move.ROCK and cpu == Move.SCISSORS) or \
	   (player == Move.PAPER and cpu == Move.ROCK) or \
	   (player == Move.SCISSORS and cpu == Move.PAPER):
		return "win"

	return "lose"


func _on_try_again_pressed():
	if last_result == "win":
		# EXIT MODE — close or hide the minigame
		queue_free()   # or emit a signal to your main scene
	else:
		# RETRY MODE
		start_game()
