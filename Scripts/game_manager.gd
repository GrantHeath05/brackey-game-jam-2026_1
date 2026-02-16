extends Node2D
# The goal with this script is one general place for all game related 
# functions to avoid needing to link multiple places

@export var fade_rect_controller_path: NodePath
@export var video_player_path: NodePath
var fade_rect_controller
var scene_player
var in_cutscene: bool = false

func _ready() -> void:
	save_fade_rect_controller_node()
	save_scene_player()
	hide_video()
	fade_from_black()
	await fade_from_black()

	# play_video("godot_ogg_test")

# input file name as a parameter. function just runs sceneplayer.play_cutscene, handles errors here thogh
func play_video(filename: String)->void:
		if !fade_rect_controller:
			print_debug("ERROR: loading fade_rect_controller_node")
			return
		if !scene_player:
			print_debug("ERROR: loading fade_rect_controller_node")
			return

		set_cutscene_flag(true)
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
	
# These functions are garbage they just link to UI_Roots functions
func fade_from_black() -> void:
	if fade_rect_controller:
		await fade_rect_controller.fade_out()
	

func save_fade_rect_controller_node ()-> void:
	fade_rect_controller = get_node_or_null(fade_rect_controller_path)

func save_scene_player ()-> void:
	scene_player = get_node_or_null(video_player_path)

func hide_video ()->void:
	scene_player.stop()
	scene_player.visible = false

func show_video()->void:
	scene_player.stop()
	scene_player.visible = true
	
func set_cutscene_flag(flag: bool)->void:
	in_cutscene = flag
	
func get_cutscene_flag()->bool:
	return in_cutscene
