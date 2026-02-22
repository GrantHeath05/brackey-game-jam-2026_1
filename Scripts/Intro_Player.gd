extends Area2D

@export var ending_panel: Control   # Drag your EndingPanel here in the Inspector

var has_played := false

func _ready():
    body_entered.connect(_on_body_entered)

func _process(_delta) -> void:
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
        # INTRO CUTSCENE
        if !GameManager.after_intro:
            await GameManager.play_video("godot_ogg_test")
            has_played = true
            GameManager.after_intro = true
            get_parent().hide()
            return

        # ENDING SEQUENCE
        if GameManager.after_intro and GameManager.all_games_completed:
            has_played = true
            ending_panel.show_ending()
            GameManager.amount_of_games_completed = 0
            GameManager.all_games_completed = false