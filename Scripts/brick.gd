extends StaticBody2D


func _on_ball_hit_brick(_node_name: String) -> void:
	# if the parameter name matches the name of the current node
	if name == _node_name:
		# delete node
		queue_free()
