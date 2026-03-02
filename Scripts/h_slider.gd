extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	connect("value_changed", _on_h_slider_value_changed)
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_h_slider_value_changed(_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(_value))
