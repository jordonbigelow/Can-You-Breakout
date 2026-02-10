extends StaticBody2D

signal destroyed(points)

@onready var color_rect := $ColorRect

var points: int = 1
var color := Color.WHITE

func _ready() -> void:
	color_rect.color = color
	add_to_group("bricks")

func destroy():
	destroyed.emit(points)
	queue_free()
