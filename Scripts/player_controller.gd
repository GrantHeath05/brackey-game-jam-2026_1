extends CharacterBody2D

@export var speed: float = 200.0
var players_input:= Vector2.ZERO
func _physics_process(_delta: float) -> void:
	movement_logic()
	player_animation()

func movement_logic() -> void:
	players_input = Vector2.ZERO

	if Input.is_action_pressed("Right"):
		players_input.x += 1

	if Input.is_action_pressed("Left"):
		players_input.x -= 1

	if Input.is_action_pressed("Down"):
		players_input.y += 1

	if Input.is_action_pressed("Up"):
		players_input.y -= 1

	if players_input != Vector2.ZERO:
		players_input = players_input.normalized()
		velocity = players_input * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func player_animation() -> void:
	var anim := ""

	if players_input == Vector2.ZERO:
		# anim = "idle"
		anim="down"
	else:
		# Determine dominant axis
		if abs(players_input.x) > abs(players_input.y):
			# Horizontal movement
			if players_input.x > 0:
				anim = "right"
			else:
				anim = "left"
		else:
			# Vertical movement
			if players_input.y > 0:
				anim = "down"
			else:
				anim = "up"
	# print_debug(anim)
	$Walking_animation.play(anim)
