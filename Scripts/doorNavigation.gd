extends Node

const scene_floor1 = preload("res://Scenes/main.tscn")
const scene_floor2 = preload("res://Scenes/upper_floor.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"main":
			scene_to_load = scene_floor1
		"upper_floor":
			scene_to_load = scene_floor2
			
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
