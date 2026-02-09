extends StaticBody2D

signal destroyed(points)

@export var points: int = 1
@export var color: Color = Color.YELLOW

func _ready() -> void:
	$ColorRect.color = color
	add_to_group("bricks")

func destroy():
	destroyed.emit(points)
	queue_free()
