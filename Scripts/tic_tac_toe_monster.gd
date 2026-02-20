extends Node2D

var player_in_range := false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$AnimationPlayer.play("Idle")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		print("Player is nearby (show interact prompt soon)")
		$Control.show_interact_prompt()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player left interaction range (hide prompt)")
		$Control.hide_interact_prompt()


func _process(_delta):
	if player_in_range:
		if Input.is_action_just_pressed("Interact"):
			print("Player interacted with NPC!")
			GameManager.show_tictactoe()
		else:
			# Player is in range but not interacting
			# This is where you'll show your 'Press E' prompt
			pass
