extends StaticBody2D

signal destroyed(points)

var points: int = 1
var color := Color.WHITE

func _ready() -> void:
	$ColorRect.color = color
	add_to_group("bricks")

func destroy():
	destroyed.emit(points)
	queue_free()
