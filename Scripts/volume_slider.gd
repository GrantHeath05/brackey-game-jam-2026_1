extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

	# Set slider to current bus volume
	var db = AudioServer.get_bus_volume_db(bus_index)
	value = db_to_linear(db)

	value_changed.connect(_on_value_changed)

func _on_value_changed(hslider_value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(hslider_value)
	)