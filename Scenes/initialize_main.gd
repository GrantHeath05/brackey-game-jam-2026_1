extends Node2D

@export var fade : NodePath
@export var video_player : NodePath
@export var pause_menu: NodePath
@export var player_node: NodePath   
@export var num_of_games_label: NodePath   
@export var lighting: NodePath
@export var debris_tilemap: NodePath
@export var front_desbris_tilemap: NodePath

@export var main_monster: NodePath
@export var rps_monster: NodePath
@export var tictactoe_monster: NodePath
@export var textbox: NodePath



func _ready() -> void:
	if fade and video_player and pause_menu and player_node and num_of_games_label and lighting and debris_tilemap and textbox:
		GameManager.register_fade_rect(get_node(fade))
		GameManager.register_video_player(get_node(video_player))
		GameManager.register_pause_menu(get_node(pause_menu))
		GameManager.register_player(get_node(player_node))
		GameManager.register_num_of_games_label(get_node(num_of_games_label))
		GameManager.register_lighting(get_node(lighting))
		GameManager.register_debris(get_node(debris_tilemap), get_node(front_desbris_tilemap))
		GameManager.register_main_monster_nodes(get_node(main_monster), get_node(rps_monster), get_node(tictactoe_monster))
		GameManager.register_textbox(get_node(textbox))


	else:
		print_debug("Something went wrong in initialize_main_menu")
		return

	await get_tree().process_frame
	GameManager.initialize_scene()

	if GameManager.spawn_door_tag != null and GameManager.spawn_door_tag != "":
		teleport_player_to_door(GameManager.spawn_door_tag)


func teleport_player_to_door(tag: String) -> void:
	var doors = get_tree().get_nodes_in_group("doors")

	for d in doors:
		if d.door_tag == tag:
			if GameManager.Player:
				GameManager.Player.global_position = d.spawn.global_position
				print_debug("Teleported player to door:", tag)
			else:
				print_debug("ERROR: Player not registered in GameManager")
			return

	print_debug("ERROR: No door found with tag:", tag)
