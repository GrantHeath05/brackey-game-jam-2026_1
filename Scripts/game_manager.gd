extends Node2D
# The goal with this script is one general place for all game related 
# functions, which manage the entire gameplay loop.
# This is a global script for every scene.
#**********************
# Player Varibles
var Player
var is_dark: bool = false

var after_intro = false
# 
#**********************
# Top left label for number of games
var num_of_games_label
# 
#**********************
# Pause Menu
var pause_menu
# 
#**********************
# Fade Varibles
var fade_rect_controller
# 
#**********************
#  Cutscene Varibles
var scene_player
var in_cutscene: bool = false
# 
#**********************
#  Door Varibles
const lower_1 = preload("res://Scenes/main.tscn")
const upper_1 = preload("res://Scenes/upper_floor.tscn")
var spawn_door_tag
signal on_trigger_player_spawn
# 
#**********************
# Game Tracking
var tictactoe_complete = false
var guess_cup_complete = false
var RPS_complete = false
var amount_of_games_completed: int = 0
var all_games_completed = false

var rock_paper_scissors
var tictactoe
var cup_game

var lighting

var debris
var front_debris

var music_started := false
var in_main_menu := true

var textbox_ui
# Monster nodes
var main_monster
var rps_monster
var tictactoe_monster
var cup_monster



func register_textbox(node):
	textbox_ui = node

func show_textbox(text: String, monster: String):
	if textbox_ui:
		textbox_ui.show_interact_prompt(text, monster)

func hide_textbox():
	if textbox_ui:
		textbox_ui.hide_interact_prompt()

func hide_debris():
	# pass
	if debris and front_debris:
		debris.visible = false
		front_debris.visible = false

		# debris.collision_layer = 0
		# debris.collision_mask = 0

func show_debris():
	# pass
	if debris and front_debris:
		debris.visible = true
		front_debris.visible = true
		# debris.collision_layer = 1
		# debris.collision_mask = 1

func _ready():
	if $MusicPlayer:
		$MusicPlayer.finished.connect(_on_music_finished)

func _on_music_finished():
	if in_main_menu or after_intro:
		$MusicPlayer.play()

func _process(_delta):
	# MAIN MENU MUSIC
	if in_main_menu:
		
		if not music_started and $MusicPlayer:
			music_started = true
			$MusicPlayer.play()
		return

	# IN-GAME MUSIC (only after intro)
	if after_intro:
		update_objective_tag("Beat Creatures at their own games")
		if not music_started and $MusicPlayer:
			music_started = true
			$MusicPlayer.play()

		show_debris()
		if lighting:
			lighting.visible = true
			Player.turn_on_player_light()
		show_all_monster()

	else:
		update_objective_tag("Find your train")
		hide_debris()
		hide_all_monster()

		if lighting:
			lighting.visible = false
			Player.turn_off_player_light()

	

# update tracking label and varibles
func update_game_tracking():
	if num_of_games_label:
		num_of_games_label.update_game_tracker_label()

# pause the game and open pause menu
func pause_game():
	pause_menu.pause()

# clear scene references for switching scenes
func clear_scene_references():
	pause_menu = null
	fade_rect_controller = null
	scene_player = null

# initialize scene (unfading from black)
func initialize_scene():
	# print_debug("Everything should be hidden")
	# print_debug("Initilizing scene")
	fade_from_black()
	pause_menu.resume()
	update_game_tracking()

func hide_all_monster():
	# print_debug("hiding monsters")
	if main_monster:
		main_monster.visible = false
	if rps_monster:
		tictactoe_monster.visible = false
	if rps_monster:
		rps_monster.visible = false
	if cup_monster:
		cup_monster.visible = false

func show_all_monster():
	if main_monster:
		main_monster.visible = true
	if rps_monster:
		tictactoe_monster.visible = true
	if rps_monster:
		rps_monster.visible = true
	if cup_monster:
		cup_monster.visible = true


func register_main_monster_nodes(temp_main_monster, temp_rps_monster, temp_tictactoe_monster):
	main_monster = temp_main_monster
	rps_monster = temp_rps_monster
	tictactoe_monster = temp_tictactoe_monster



func register_upper_monster_nodes(temp_cup_monster):
	cup_monster = temp_cup_monster



# print_debug("Everything should be hidden")
func register_debris(debris_layer: TileMapLayer, front_debris_layer: TileMapLayer):
	debris = debris_layer
	front_debris = front_debris_layer

func register_lighting(node):
	lighting = node
func register_num_of_games_label(node):
	num_of_games_label = node

# register function for player script to register(self)
func register_pause_menu(node):
	pause_menu = node
	# print_debug("initilized: ", node)

# register function for player script to register(self)
func register_player(node):
	Player = node
	# print_debug("initilized: ", node)

# register function for player script to register(self)
func register_video_player(node):
	scene_player = node
	# print_debug("initilized: ", node)

# register function for player script to register(self)
func register_fade_rect(node):
	fade_rect_controller = node
	# print_debug("initilized: ", node)

# register RPS game
func register_RPS(node):
	rock_paper_scissors = node
	# print_debug("initilized: ", node)
# register RPS game
func register_cup_game(node):
	cup_game = node
	# print_debug("initilized: ", node)
# register RPS game
func register_tictactoe(node):
	tictactoe = node
	# print_debug("initilized: ", node)

# input file name as a parameter. function just runs sceneplayer.play_cutscene, handles errors here thogh
func play_video(filename: String)->void:
		if !fade_rect_controller:
			print_debug("ERROR: loading fade_rect_controller_node")
			return
		if !scene_player:
			print_debug("ERROR: loading fade_rect_controller_node")
			return

		in_cutscene = true
		# get_tree().paused = true
		show_video()

		await fade_to_black()
		scene_player.visible = true
		scene_player.play_cutscene(filename)
		await scene_player.finished
		after_intro = true
		hide_video()

		await fade_from_black()

		in_cutscene = false

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

# Hide video screen
func hide_video ()->void:
	if scene_player:
		scene_player.stop()
		scene_player.visible = false

# Unhide video screen
func show_video()->void:
	if scene_player:
		scene_player.stop()
		scene_player.visible = true

# Transfers player to level using parameters level_tag and destination_tag. mainly used for doors
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

# player spawn trigger for doors
func trigger_player_spawn(PlayerPosition: Vector2, direction: String):
	on_trigger_player_spawn.emit(PlayerPosition, direction)

# turn off players light effect if it exists
func turn_off_player_light():
	if Player:
		var light = Player.get_node("PointLight2D")
		if light:
			light.visible = false

# turn on players light effect if it exists
func turn_on_player_light():
	if Player:
		var light = Player.get_node("PointLight2D")
		if light:
			light.visible = true

# load new scene with fade effect
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

	# print_debug("wait for new scene to process")
	# 4. Wait one frame so the new scene can run _ready()
	await get_tree().process_frame

	update_game_tracking()

	# 5. Now the new scene should have registered its UI
	#    Fade from black using the NEW fade rect
	if fade_rect_controller:
		# print_debug("new fade controller found")
		await fade_rect_controller.fade_out()
		fade_rect_controller.visible = false
	if pause_menu:
		pause_menu.resume()

# updates objective tag using a String parameter called 'tag'
func update_objective_tag(tag: String):
	pause_menu.edit_objective_txt(tag)


func show_cup_game():
	print_debug("Cup game has been unhidden")
	cup_game.visible = true

func show_RPS():
	print_debug("rock paper scissors has been unhidden")
	rock_paper_scissors.visible = true


func show_tictactoe():
	print_debug("tictactoe has been unhidden")
	tictactoe.visible = true
