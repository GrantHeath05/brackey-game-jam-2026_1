extends Control

@export var x_icon: Texture2D
@export var o_icon: Texture2D
@export var blank_icon: Texture2D

@export var Current_Turn: Label
@export var ResultLabel: Label
@export var RestartButton: Button

var board := []
var cells := []
var player_turn := true
var game_over := false
var first_launch := true   # <-- NEW

func _ready():
    board.resize(9)
    board.fill(" ")

    # START BUTTON MODE
    RestartButton.visible = true
    RestartButton.text = "Start"
    ResultLabel.text = ""

    _cache_cells()
    _connect_buttons()
    _initialize_blank_icons()

    # Disable board until Start is pressed
    game_over = true
    Current_Turn.text = ""

func _cache_cells():
    for i in range(9):
        cells.append($GridContainer.get_child(i))

func _connect_buttons():
    for i in range(9):
        cells[i].pressed.connect(_on_cell_pressed.bind(i))

func _set_icon(index, tex):
    cells[index].texture_normal = tex
    cells[index].texture_hover = tex
    cells[index].texture_pressed = tex

func _initialize_blank_icons():
    for i in range(9):
        _set_icon(i, blank_icon)

func start_game():
    board.fill(" ")
    for i in range(9):
        _set_icon(i, blank_icon)

    game_over = false
    player_turn = true

    ResultLabel.text = ""
    RestartButton.visible = false

    _update_turn_label()

func _on_cell_pressed(index):
    if game_over or not player_turn:
        return
    if board[index] != " ":
        return

    board[index] = "X"
    _set_icon(index, x_icon)

    if _check_win("X"):
        _end_game("Winner")
        return

    if _board_full():
        _end_game("Tie")
        return

    player_turn = false
    _update_turn_label()

    await get_tree().create_timer(0.3).timeout
    _cpu_move()

func _cpu_move():
    if game_over:
        return

    var empty := []
    for i in range(9):
        if board[i] == " ":
            empty.append(i)

    if empty.is_empty():
        _end_game("Tie")
        return

    var choice = empty[randi() % empty.size()]
    board[choice] = "O"
    _set_icon(choice, o_icon)

    if _check_win("O"):
        _end_game("Loser")
        return

    if _board_full():
        _end_game("Tie")
        return

    player_turn = true
    _update_turn_label()

func _check_win(symbol):
    var wins = [
        [0,1,2], [3,4,5], [6,7,8],
        [0,3,6], [1,4,7], [2,5,8],
        [0,4,8], [2,4,6]
    ]

    for combo in wins:
        if board[combo[0]] == symbol and board[combo[1]] == symbol and board[combo[2]] == symbol:
            return true

    return false

func _board_full():
    for v in board:
        if v == " ":
            return false
    return true

func _end_game(result_text):
    game_over = true
    ResultLabel.text = result_text
    Current_Turn.text = ""

    if result_text == "Winner":
        RestartButton.text = "Exit"
        RestartButton.visible = true
        won()
    else:
        RestartButton.text = "Try Again"
        RestartButton.visible = true

func _update_turn_label():
    if game_over:
        Current_Turn.text = ""
        return

    if player_turn:
        Current_Turn.text = "Your Turn"
    else:
        Current_Turn.text = "CPU Turn"

func reset():
    start_game()

func _on_restart_button_pressed():
    if first_launch:
        first_launch = false
        start_game()
        return

    if ResultLabel.text == "Winner":
        self.visible = false   # EXIT MODE
    else:
        reset()                # RETRY MODE

func won():
    print_debug("Player won tic tac toe")