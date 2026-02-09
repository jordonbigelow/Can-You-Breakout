extends Node2D

@export var brick_scene: PackedScene = load("res://Scenes/brick.tscn")
@export var columns := 10
@export var rows := 5
@export var brick_size := Vector2(100, 20)
@export var spacing := Vector2(8, 8)
@export var start_pos := Vector2(100, 100)

@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var paddle: CharacterBody2D = $Paddle
@onready var timer: Timer = $Timer
@onready var ball_origin = Vector2(593.0, 683.0)
@onready var paddle_origin = Vector2(593.0, 710.0)
@onready var score: int = 0
@onready var lives: int = 3
@onready var children: Array = get_children()
@onready var hud := $UI/HUD/HBoxContainer
@onready var main_menu: PackedScene = load("res://Scenes/main_menu.tscn")
@onready var brick_count = get_tree().get_nodes_in_group("bricks").size()

func _ready() -> void:
	hud.get_child(0).text += str(score)
	hud.get_child(1).text += str(lives)
	_spawn_bricks()
	_spawn_ball()
	paddle.position = paddle_origin

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name.contains("Ball"):
		if lives > 1:
			lives -= 1
			hud.get_child(1).text = "Lives: %s" % str(lives)
			body.queue_free()
			get_tree().paused = true
			timer.start()
			paddle.position = paddle_origin
		else:
			print("Game Over Score: ", score)
			_change_to_main_menu()

func _on_timer_timeout() -> void:
	get_tree().paused = false
	_spawn_ball()

func _get_brick_count() -> int:
	brick_count = get_tree().get_nodes_in_group("bricks").size()
	return brick_count
	
func _change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)

func _spawn_ball():
	var ball = ball_scene.instantiate()
	ball.position = ball_origin
	add_child(ball)
	ball.hit_brick.connect(_on_ball_hit_brick)
	
func _spawn_bricks():
	for row in rows:
		for col in columns:
			var brick = brick_scene.instantiate()
			if row == 0:
				brick.color = Color.RED
				brick.points = 20
			elif row == 1:
				brick.color = Color.ORANGE_RED
				brick.points = 10
			elif row == 2:
				brick.color = Color.ORANGE
				brick.points = 7
			elif row == 3: 
				brick.color = Color.YELLOW
				brick.points = 5
			elif row == 4:
				brick.color = Color.LIME_GREEN
				brick.points = 3
			elif row == 5:
				brick.color = Color.BLUE
				brick.points = 1
				
			var x = start_pos.x + col * (brick_size.x + spacing.x)
			var y = start_pos.y + row * (brick_size.y + spacing.y)
			brick.position = Vector2(x, y)
			get_child(-1).add_child(brick)

func _on_ball_hit_brick(brick) -> void:
	score += brick.points
	hud.get_child(0).text = "Score: %s" % str(score)
	print(_get_brick_count())
	if _get_brick_count() < 1:
		print("you've won!")
		_change_to_main_menu()
	brick.destroy()
