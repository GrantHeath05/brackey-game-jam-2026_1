extends Node2D

@export var fade : NodePath
@export var video_player : NodePath
@export var pause_menu: NodePath
var button_type = null

#center coords
var center : Vector2
@onready var node = $MovingBg
@onready var node2 = $MovingBg2

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

# calculate center of screen
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
#menu cam movement
func _process(_delta):
	var tween = node.create_tween()
	var offset = center - get_global_mouse_position() * 0.05
	tween.tween_property(node,"position", offset, 1.0)
	
	var tween2 = node2.create_tween()
	var offset2 = center - get_global_mouse_position() * 0.03
	tween2.tween_property(node2,"position", offset2, 1.0)

func _on_quit_pressed() -> void:
	# print_debug("Quit was pressed")
	get_tree().quit()



func _on_settings_pressed() -> void:
	# print_debug("Settings was pressed")
	GameManager.pause_game()

func _on_start_pressed() -> void:
	#print_debug("Start has been pressed")
	button_type = "start"

	GameManager.in_main_menu = false
	GameManager.after_intro = false
	GameManager.music_started = false

	if GameManager.has_node("MusicPlayer"):
		GameManager.get_node("MusicPlayer").stop()

	$fadeout.show()
	$fadeout/fadeTimer.start()
	$fadeout/AnimationPlayer.play("menu_fadein")



func _on_fade_timer_timeout() -> void:
	if button_type == "start" :
		# print_debug("Start has been pressed")
		GameManager.clear_scene_references()
		GameManager.load_scene_with_fade(load(main_route))
		# print_debug('Attempting to load:', main_route)
