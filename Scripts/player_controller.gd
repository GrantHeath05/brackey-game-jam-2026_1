extends CharacterBody2D

@export var speed: float = 200.0

var players_input := Vector2.ZERO
var last_direction := "down"   # Used for idle animations


func _physics_process(_delta: float) -> void:
	movement_logic()
	player_animation()
	handle_footsteps()


# -------------------------
# MOVEMENT
# -------------------------
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


# -------------------------
# FOOTSTEP SOUND
# -------------------------
func handle_footsteps() -> void:
	var moving := players_input != Vector2.ZERO

	if moving and not $footstep_sound.playing:
		$footstep_sound.play()

	if not moving and $footstep_sound.playing:
		$footstep_sound.stop()


# -------------------------
# ANIMATION
# -------------------------
func player_animation() -> void:
	var is_moving := players_input != Vector2.ZERO
	var direction := get_facing_direction()

	if is_moving:
		$Walking_animation.play("walk_" + direction)
	else:
		$Walking_animation.play("idle_" + direction)


# -------------------------
# DIRECTION HELPER
# -------------------------
func get_facing_direction() -> String:
	# Update last_direction only when moving
	if players_input != Vector2.ZERO:

		# Horizontal dominates
		if abs(players_input.x) > abs(players_input.y):
			if players_input.x > 0:
				last_direction = "right"
			else:
				last_direction = "left"

		# Vertical dominates
		else:
			if players_input.y > 0:
				last_direction = "down"
			else:
				last_direction = "up"

	return last_direction