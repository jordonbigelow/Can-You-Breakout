extends Node2D

@onready var ball: PackedScene = preload("res://Scenes/ball.tscn")
@onready var paddle: CharacterBody2D = $Paddle
@onready var timer: Timer = $Timer
@onready var ball_origin = Vector2(593.0, 683.0)
@onready var paddle_origin = Vector2(593.0, 710.0)
@onready var score: int = 0
@onready var lives: int = 3
@onready var children: Array = get_children()
@onready var hud := $UI/HUD/HBoxContainer
@onready var main_menu: PackedScene = load("res://Scenes/main_menu.tscn")

func _ready() -> void:
	for child in children:
		if child.name.contains("Brick"):
			print(child.name)
	
	hud.get_child(0).text += str(score)
	hud.get_child(1).text += str(lives)

func _process(_delta: float) -> void:
	if lives <= 0:
		print("Game Over Score: ", score)
		get_tree().change_scene_to_packed(main_menu)
		#get_tree().paused = true
		
func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name.contains("Ball"):
		body.queue_free()
		get_tree().paused = true
		timer.start()
		paddle.position = paddle_origin

func _on_timer_timeout() -> void:
	get_tree().paused = false
	var instance = ball.instantiate()
	instance.position = ball_origin
	add_child(instance)

func _on_child_exiting_tree(node: Node) -> void:
	if node.name.contains("Brick"):
		score += 1
		hud.get_child(0).text = "Score: %s" % str(score)
	elif node.name.contains("Ball") and lives >= 0:
		lives -= 1
		hud.get_child(1).text = "Lives: %s" % str(lives)
