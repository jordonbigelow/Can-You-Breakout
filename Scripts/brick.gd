extends StaticBody2D

func _ready() -> void:
	add_to_group("bricks")

func _on_ball_hit_brick(_node_name: String) -> void:
	if name == _node_name:
		queue_free()
