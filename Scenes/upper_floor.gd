extends Node2D

@export var fade : NodePath
@export var video_player : NodePath
@export var pause_menu: NodePath
@export var player_node: NodePath
@export var num_of_games_label: NodePath   
@export var lighting: NodePath   


func _ready() -> void:
	# Register UI components with GameManager
	if fade and video_player and pause_menu and lighting and num_of_games_label:
		GameManager.register_fade_rect(get_node(fade))
		GameManager.register_video_player(get_node(video_player))
		GameManager.register_pause_menu(get_node(pause_menu))
		GameManager.register_player(get_node(player_node))
		GameManager.register_num_of_games_label(get_node(num_of_games_label))
		GameManager.register_lighting(get_node(lighting))



	else:
		print_debug("Something went wrong in initialize_main_menu")
		return

	await get_tree().process_frame
	GameManager.initialize_scene()

	# Teleport player to correct door
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
