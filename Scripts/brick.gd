extends StaticBody2D


func _on_ball_hit_brick(node_name: String) -> void:
	if name == node_name:
		queue_free()
