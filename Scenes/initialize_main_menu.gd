extends Node2D

@export var fade : NodePath
@export var video_player : NodePath
@export var pause_menu: NodePath

var main_route: String = 'res://Scenes/main.tscn'

func _ready() -> void:
	if fade and video_player and pause_menu:
		GameManager.register_fade_rect(get_node(fade))
		GameManager.register_video_player(get_node(video_player))
		GameManager.register_pause_menu(get_node(pause_menu))
	else:
		print_debug("Somethinig went wrong in initalize_main_menu")
		return

	await get_tree().process_frame
	GameManager.initialize_scene()	


func _on_quit_pressed() -> void:
	print_debug("Quit was pressed")
	get_tree().quit()



func _on_settings_pressed() -> void:
	print_debug("Settings was pressed")
	GameManager.pause_game()

func _on_start_pressed() -> void:
	print_debug("Start has been pressed")
	GameManager.clear_scene_references()
	GameManager.load_scene_with_fade(load(main_route))
	print_debug('Attempting to load:', main_route)

