extends Control

var cups := []
var positions := []
var rock_index := 0
var input_enabled := false


func _ready():
	cups = [
		$Panel/Cup_1_Main,
		$Panel/Cup_2,
		$Panel/Cup_3
	]

	# Store original positions for reset
	positions = cups.map(func(c): return c.position)

	# Hide Try Again button at startup
	$Panel/Try_Again.visible = false

	disable_input()
	start_game()


# ---------------------------------------------------------
# GAME FLOW
# ---------------------------------------------------------

func start_game():
	rock_index = 0  # Cup 1 always has the rock

	# Hide results + button
	$Panel/Results.text = ""
	$Panel/Try_Again.visible = false

	# Play the animation on Cup_1_Main
	$AnimationPlayer.play("Showing_Rock")
	await $AnimationPlayer.animation_finished

	shuffle()


func shuffle():
	for i in range(5):
		var a = randi() % 3
		var b = randi() % 3
		if a != b:
			var t = swap_cups(a, b)
			await t.finished

	enable_input()


# ---------------------------------------------------------
# SWAP LOGIC
# ---------------------------------------------------------

func swap_cups(a, b):
	var tween = create_tween()

	var pos_a = cups[a].position
	var pos_b = cups[b].position
	var mid = (pos_a + pos_b) / 2

	tween.tween_property(cups[a], "position", mid, 0.25)
	tween.tween_property(cups[a], "position", pos_b, 0.25)

	tween.parallel().tween_property(cups[b], "position", mid, 0.25)
	tween.parallel().tween_property(cups[b], "position", pos_a, 0.25)

	# Swap logical positions
	var temp = cups[a]
	cups[a] = cups[b]
	cups[b] = temp

	# Rock stays with Cup_1_Main
	rock_index = cups.find($Panel/Cup_1_Main)

	return tween


# ---------------------------------------------------------
# INPUT HANDLING
# ---------------------------------------------------------

func enable_input():
	input_enabled = true
	for c in cups:
		c.mouse_filter = Control.MOUSE_FILTER_STOP

func disable_input():
	input_enabled = false
	for c in cups:
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE


# ---------------------------------------------------------
# REVEAL LOGIC
# ---------------------------------------------------------

func reveal(cup_node):
	disable_input()

	var index = cups.find(cup_node)

	# Reveal Cup_1_Main wherever it currently is
	$AnimationPlayer.play_backwards("Showing_Rock")
	await $AnimationPlayer.animation_finished

	if index == rock_index:
		print("WIN")
		$Panel/Results.text = "Winner"

		# Close UI or hide it — your choice
		# queue_free()
		# visible = false
	else:
		print("LOSE")
		$Panel/Results.text = "Loser"

		# Show Try Again button ONLY on loss
		$Panel/Try_Again.visible = true


# ---------------------------------------------------------
# CLICK SIGNALS
# ---------------------------------------------------------

func _on_cup_1_gui_input(event):
	if input_enabled and event is InputEventMouseButton and event.pressed:
		reveal($Panel/Cup_1_Main)

func _on_cup_2_gui_input(event):
	if input_enabled and event is InputEventMouseButton and event.pressed:
		reveal($Panel/Cup_2)

func _on_cup_3_gui_input(event):
	if input_enabled and event is InputEventMouseButton and event.pressed:
		reveal($Panel/Cup_3)


# ---------------------------------------------------------
# RESET / TRY AGAIN
# ---------------------------------------------------------

func _on_try_again_pressed():
	reset_game()


func reset_game():
	disable_input()

	# Reset cup positions
	for i in range(cups.size()):
		cups[i].position = positions[i]

	# Reset logical order
	cups = [
		$Panel/Cup_1_Main,
		$Panel/Cup_2,
		$Panel/Cup_3
	]

	# Reset rock
	rock_index = 0

	# Hide UI elements
	$Panel/Results.text = ""
	$Panel/Try_Again.visible = false

	# Restart the game
	start_game()
