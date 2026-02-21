extends Area2D

var has_played := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if has_played:
		return

	if body.is_in_group("Player"):
		await GameManager.play_video("godot_ogg_test")
		has_played = true
		GameManager.after_intro = true
		get_parent().hide()
