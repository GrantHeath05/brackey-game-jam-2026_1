extends Control

@export var action_name: String = "Interact"

@export var panel: Panel
@export var rich_text: RichTextLabel
@export var main_monster: Sprite2D
@export var cup_monster: Sprite2D
@export var ttt_monster: Sprite2D
@export var rps_monster: Sprite2D
@export var close_label: Label

func _ready():
	hide_interact_prompt()

func show_interact_prompt(text: String = "", monster: String = "") -> void:
	if rich_text:
		rich_text.text = text

	_hide_all_monsters()

	match monster:
		"Main":
			if main_monster: main_monster.visible = true
		"Cup":
			if cup_monster: cup_monster.visible = true
		"TicTacToe":
			if ttt_monster: ttt_monster.visible = true
		"RPS":
			if rps_monster: rps_monster.visible = true

	var key = _get_first_key_for_action(action_name)
	if close_label:
		close_label.text = "Press %s to close window" % key

	visible = true

func hide_interact_prompt() -> void:
	visible = false
	_hide_all_monsters()

func _hide_all_monsters():
	if main_monster: main_monster.visible = false
	if cup_monster: cup_monster.visible = false
	if ttt_monster: ttt_monster.visible = false
	if rps_monster: rps_monster.visible = false

func _get_first_key_for_action(key_name: String) -> String:
	var events = InputMap.action_get_events(key_name)
	for e in events:
		if e is InputEventKey:
			return OS.get_keycode_string(e.physical_keycode)
	return "Unknown"
