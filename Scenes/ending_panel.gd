extends PanelContainer

func show_ending():
	visible = true
	modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)

func _on_button_pressed() -> void:
	var main_menu = load("res://Scenes/main_menu.tscn")
	GameManager.load_scene_with_fade(main_menu)
