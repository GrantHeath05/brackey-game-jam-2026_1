extends PanelContainer

@onready var label := $Label
@onready var anim := $AnimationPlayer

var size_preset := "large"

var ui_presets := {
	"small": {
		"height_percent": 0.08,
		"font_percent": 0.015
	},
	"medium": {
		"height_percent": 0.10,
		"font_percent": 0.020
	},
	"large": {
		"height_percent": 0.12,
		"font_percent": 0.030
	},
	"extra_large": {
		"height_percent": 0.14,
		"font_percent": 0.040
	}
}

func _ready():
	apply_preset(size_preset)
	quick_hide_box()


# ---------------------------------------------------------
# TEXT
# ---------------------------------------------------------

func set_text(new_text: String):
	# Add lines above and below + spaces before and after text
	var line := "    "
	label.text = line + "\n  " + new_text + "  \n" + line
	_resize_width()

func append_text(extra: String):
	var line := "    "
	label.text = line + "\n  Objective: " + extra + "  \n" + line
	_resize_width()


# ---------------------------------------------------------
# ANIMATIONS
# ---------------------------------------------------------

func show_box():
	visible = true
	anim.play("Show_Objective_Panel")

func hide_box():
	anim.play("Hide_Objective_Panel")

func quick_hide_box():
	anim.play("quick_hide")


# ---------------------------------------------------------
# APPLY PRESET
# ---------------------------------------------------------

func apply_preset(preset_type: String):
	if not ui_presets.has(preset_type):
		push_warning("Unknown UI preset: %s" % preset_type)
		return

	size_preset = preset_type
	var preset = ui_presets[preset_type]

	var screen := get_viewport_rect().size

	# Set height only
	var h: float = screen.y * preset["height_percent"]
	custom_minimum_size.y = h

	# Set font size
	var font_size: int = int(screen.x * preset["font_percent"])
	label.add_theme_font_size_override("font_size", font_size)

	_resize_width()


# ---------------------------------------------------------
# AUTO-EXPAND WIDTH BASED ON TEXT
# ---------------------------------------------------------

func _resize_width():
	await get_tree().process_frame

	var text_width = label.get_minimum_size().x
	var padding = get_theme_stylebox("panel").get_minimum_size().x

	# Add extra breathing room + your requested 50 units
	var extra = 50.0

	custom_minimum_size.x = text_width + padding + extra