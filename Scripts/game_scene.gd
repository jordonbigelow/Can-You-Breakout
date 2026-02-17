extends Node2D

signal game_over

@export var brick_scene: PackedScene = load("res://Scenes/brick.tscn")
@export var columns := 16
@export var rows := 8
@export var brick_size := Vector2(74, 15)
@export var spacing := Vector2(4, 6)
@export var start_pos := Vector2(20, 50)
@export var lives: int = 3

@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var paddle: CharacterBody2D = $Paddle
@onready var timer: Timer = $Timer
@onready var ball_origin = Vector2(593.0, 683.0)
@onready var paddle_origin = Vector2(593.0, 710.0)
@onready var score: int = 0
@onready var hud := $UI/HUD/HBoxContainer
@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")
@onready var brick_count = get_tree().get_nodes_in_group("bricks").size()
@onready var pause_menu := $PauseMenu
@onready var sound_effects := $SoundEffects

func _ready() -> void:
	hud.get_child(0).text += str(score)
	hud.get_child(1).text += str(lives)
	_spawn_bricks()
	_spawn_ball()
	paddle.position = paddle_origin

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()

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
			game_over.emit()

func _on_timer_timeout() -> void:
	get_tree().paused = false
	_spawn_ball()

func _get_brick_count() -> int:
	brick_count = get_tree().get_nodes_in_group("bricks").size()
	return brick_count
	
func _change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

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
				brick.color = Color.GREEN_YELLOW
				brick.points = 4
			elif row == 5:
				brick.color = Color.LIME_GREEN
				brick.points = 3
			elif row == 6: 
				brick.color = Color.DEEP_SKY_BLUE
				brick.points = 2
			elif row == 7:
				brick.color = Color.ROYAL_BLUE
				brick.points = 1
			var x = start_pos.x + col * (brick_size.x + spacing.x)
			var y = start_pos.y + row * (brick_size.y + spacing.y)
			brick.position = Vector2(x, y)
			add_child(brick)

func _on_ball_hit_brick(brick) -> void:
	score += brick.points
	hud.get_child(0).text = "Score: %s" % str(score)
	sound_effects.play(0.89)
	if _get_brick_count() == 0:
		print("you've won!")
		brick.destroy()
		_change_to_main_menu()
	brick.destroy()

func _on_ceiling_body_entered(body: Node2D) -> void:
	if body.name.contains("Ball"):
		print("you win")
		game_over.emit()

func _on_game_over() -> void:
	_change_to_main_menu()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	_change_to_main_menu()
