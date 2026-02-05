extends Node2D

@onready var ball: PackedScene = preload("res://Scenes/ball.tscn")
@onready var paddle: CharacterBody2D = $Paddle
@onready var timer: Timer = $Timer
@onready var ball_origin = Vector2(593.0, 683.0)
@onready var paddle_origin = Vector2(593.0, 710.0)

func _on_kill_zone_body_entered(body: Node2D) -> void:
	print("hello world")
	body.queue_free()
	timer.start()
	paddle.position = paddle_origin

func _on_timer_timeout() -> void:
	var instance = ball.instantiate()
	#ball.connect("hit_brick", ball.hit_brick())
	instance.position = ball_origin
	add_child(instance)
