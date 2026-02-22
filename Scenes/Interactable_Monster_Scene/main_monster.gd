extends Node2D

var monster_type = "Main"

var player_in_range := false
var waiting_for_prompt_close := false
var textbox_open := false

# Dialogue for each stage
var dialogue_0 = "It appears you’ve fallen through the cracks of your world, and now you’re stuck here with the rest of God’s forgotten creatures. 
Worry not! there’s still time to return, 
but not for long. Entertain these beings by playing their games, 
and they’ll fix the train for you and send you on your way. One creature lives on the upper level that connects the platforms, 
and the other two are split between the upper and lower platforms. Come back here when you're done with them"
var dialogue_1 = "You’ve beaten one of them? Impressive. But there are still two more waiting for you. Until then I will be here"
var dialogue_2 = "Two games down? You’re getting close to being free. Only one more challenge remains. I will be waiting."
var dialogue_3 = "All three games completed… We are creatures of our word."

func _ready():
    $Area2D.body_entered.connect(_on_body_entered)
    $Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
    if body.is_in_group("Player"):
        player_in_range = true
        $Control.show_interact_prompt()
        waiting_for_prompt_close = true

func _on_body_exited(body):
    if body.is_in_group("Player"):
        player_in_range = false
        waiting_for_prompt_close = false
        textbox_open = false

        $Control.hide_interact_prompt()
        GameManager.hide_textbox()

func _process(_delta):
    if not visible:
        return
    if not player_in_range:
        return

    # STEP 1: Close small prompt → open textbox
    if waiting_for_prompt_close:
        if Input.is_action_just_pressed("Interact"):
            $Control.hide_interact_prompt()
            waiting_for_prompt_close = false

            var text = get_dialogue()
            GameManager.show_textbox(text, monster_type)

            textbox_open = true
        return

    # STEP 2: Close textbox → allow re-interaction
    if textbox_open:
        if Input.is_action_just_pressed("Interact"):
            GameManager.hide_textbox()
            textbox_open = false

            # Trigger event if all games completed
            if GameManager.all_games_completed:
                on_all_games_completed()

            waiting_for_prompt_close = true
            $Control.show_interact_prompt()

        return


func get_dialogue() -> String:
    var count = GameManager.amount_of_games_completed

    match count:
        0:
            return dialogue_0
        1:
            return dialogue_1
        2:
            return dialogue_2
        3:
            return dialogue_3
        _:
            return dialogue_0


func on_all_games_completed():
    # Placeholder for your final event
    pass