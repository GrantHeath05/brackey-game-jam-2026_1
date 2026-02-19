extends Node2D
# The goal with this script is one general place for all game related 
# functions to avoid needing to link multiple places

var Player

#**********************
# Pause Menu
var pause_menu

#**********************
# Fade Varibles
var fade_rect_controller


#**********************
#  Cutscene Varibles
var scene_player
var in_cutscene: bool = false


#**********************
#  Door Varibles
const lower_1 = preload("res://Scenes/main.tscn")
const upper_1 = preload("res://Scenes/upper_floor.tscn")
var spawn_door_tag

signal on_trigger_player_spawn
#**********************

func pause_game():
	pause_menu.pause()

func clear_scene_references():
	pause_menu = null
	fade_rect_controller = null
	scene_player = null

func initialize_scene():
	# print_debug("Everything should be hidden")
	print_debug("Initilizing scene")
	fade_from_black()
	pause_menu.resume()
	# print_debug("Everything should be hidden")
	pause_menu.edit_objective_txt("test")

func register_pause_menu(node):
	pause_menu = node
	# print_debug("initilized: ", node)

func register_player(node):
	Player = node
	# print_debug("initilized: ", node)

#  Lets other functions register themselves with game manager
func register_video_player(node):
	scene_player = node
	# print_debug("initilized: ", node)

#  Lets other functions register themselves with game manager
func register_fade_rect(node):
	fade_rect_controller = node
	# print_debug("initilized: ", node)


# input file name as a parameter. function just runs sceneplayer.play_cutscene, handles errors here thogh
func play_video(filename: String)->void:
		if !fade_rect_controller:
			print_debug("ERROR: loading fade_rect_controller_node")
			return
		if !scene_player:
			print_debug("ERROR: loading fade_rect_controller_node")
			return

		set_cutscene_flag(true)
		# get_tree().paused = true
		show_video()

		await fade_to_black()
		scene_player.visible = true
		scene_player.play_cutscene(filename)
		await scene_player.finished
		hide_video()

		await fade_from_black()

		set_cutscene_flag(false)



# These functions are garbage they just link to UI_Roots functions
func fade_to_black() -> void:
	if fade_rect_controller:
		await fade_rect_controller.fade_in()
		fade_rect_controller.visible = true
	
# These functions are garbage they just link to UI_Roots functions
func fade_from_black() -> void:
	if fade_rect_controller:
		await fade_rect_controller.fade_out()
		fade_rect_controller.visible = false

func hide_video ()->void:
	if scene_player:
		scene_player.stop()
		scene_player.visible = false

func show_video()->void:
	if scene_player:
		scene_player.stop()
		scene_player.visible = true
	
func set_cutscene_flag(flag: bool)->void:
	in_cutscene = flag
	
func get_cutscene_flag()->bool:
	return in_cutscene

func go_to_level(level_tag, destination_tag) -> void:
	# Fade out old scene
	if fade_rect_controller:
		await fade_rect_controller.fade_in()

	# Store which door to spawn at
	spawn_door_tag = destination_tag

	# Clear old UI references
	clear_scene_references()

	# Pick scene
	var scene_to_load
	match level_tag:
		"main":
			scene_to_load = lower_1
		"upper_floor":
			scene_to_load = upper_1

	# Change scene
	if scene_to_load:
		get_tree().change_scene_to_packed(scene_to_load)

	# Wait for new scene to initialize
	await get_tree().process_frame

	# Fade in new scene
	if fade_rect_controller:
		await fade_rect_controller.fade_out()
		fade_rect_controller.visible = false



func trigger_player_spawn(PlayerPosition: Vector2, direction: String):
	on_trigger_player_spawn.emit(PlayerPosition, direction)

func load_scene_with_fade(scene: PackedScene):
	# 1. Fade to black using the OLD fade rect
	if fade_rect_controller:
		# print_debug("old fade controller found")
		await fade_rect_controller.fade_in()
		# print_debug("faded in")

	# print_debug("clear old node references")
	# 2. Clear old references
	clear_scene_references()

	# print_debug("change scene")
	# 3. Change scene
	get_tree().change_scene_to_packed(scene)

	print_debug("wait for new scene to process")
	# 4. Wait one frame so the new scene can run _ready()
	await get_tree().process_frame

	# 5. Now the new scene should have registered its UI
	#    Fade from black using the NEW fade rect
	if fade_rect_controller:
		print_debug("new fade controller found")
		await fade_rect_controller.fade_out()
		fade_rect_controller.visible = false
		print_debug("new fade controller found")
	if pause_menu:
		pause_menu.resume()
