extends Control

var cups := []
var positions := []
var rock_index := 0
var input_enabled := false
var last_result := ""
var first_launch := true   # <-- NEW

func _ready():
	cups = [
		$Panel/Cup_1_Main,
		$Panel/Cup_2,
		$Panel/Cup_3
	]

	positions = cups.map(func(c): return c.position)

	# START BUTTON MODE
	$Panel/Try_Again.visible = true
	$Panel/Try_Again.text = "Start"

	disable_input()


# ---------------------------------------------------------
# GAME FLOW
# ---------------------------------------------------------

func start_game():
	rock_index = 0

	$Panel/Results.text = ""
	$Panel/Try_Again.visible = false
	$Panel/Try_Again.text = ""

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

	var temp = cups[a]
	cups[a] = cups[b]
	cups[b] = temp

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

	$AnimationPlayer.play_backwards("Showing_Rock")
	await $AnimationPlayer.animation_finished

	if index == rock_index:
		last_result = "win"
		$Panel/Results.text = "Winner"
		$Panel/Try_Again.text = "Exit"
		$Panel/Try_Again.visible = true
		won()
	else:
		last_result = "lose"
		$Panel/Results.text = "Loser"
		$Panel/Try_Again.text = "Try Again"
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
# RESET / TRY AGAIN / EXIT / START
# ---------------------------------------------------------

func _on_try_again_pressed():
	if first_launch:
		first_launch = false
		start_game()
		return

	if last_result == "win":
		self.visible = false   # EXIT
	else:
		reset_game()           # RETRY


func reset_game():
	disable_input()

	for i in range(cups.size()):
		cups[i].position = positions[i]

	cups = [
		$Panel/Cup_1_Main,
		$Panel/Cup_2,
		$Panel/Cup_3
	]

	rock_index = 0

	$Panel/Results.text = ""
	$Panel/Try_Again.visible = false

	start_game()


func won():
	print_debug("player won guess_the_cup_game")
	GameManager.guess_cup_complete = true
	GameManager.update_game_tracking()