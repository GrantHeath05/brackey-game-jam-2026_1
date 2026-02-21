extends Area2D

var has_played := false

func _ready():
	body_entered.connect(_on_body_entered)

func _process(_float)->void:
	if !GameManager.after_intro:
		get_parent().show()
	elif GameManager.all_games_completed:
		get_parent().show()
	else:
		get_parent().hide()


func _on_body_entered(body):
	if has_played:
		return

	if body.is_in_group("Player"):
		if !GameManager.after_intro:
			await GameManager.play_video("godot_ogg_test")
			has_played = true
			GameManager.after_intro = true
			get_parent().hide()
		elif GameManager.after_intro and GameManager.all_games_completed:
			print_debug("YOU WIN SCREEN HERE")
			get_parent().show()
