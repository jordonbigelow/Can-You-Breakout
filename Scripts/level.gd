extends Node

signal level_game_over(score: int)
signal ball_entered_killzone
signal ball_broke_out(score: int)
signal ball_hit_brick
signal ball_hit_wall
signal ball_hit_paddle

@export var level: int
@export var brick_scene: PackedScene = load("res://Scenes/brick.tscn")
@export var columns := 16
@export var rows := 8
@export var brick_size := Vector2(74, 15)
@export var spacing := Vector2(4, 6)
@export var start_pos := Vector2(20, 50)
@export var lives: int = 3

@onready var score: int

@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var main_menu_scene: PackedScene = preload("res://Scenes/main_menu.tscn")

@onready var paddle: CharacterBody2D = $Paddle
@onready var timer: Timer = $Timer
@onready var hud := $UI/HUD/HBoxContainer
@onready var ceiling := $Ceiling
@onready var kill_zone := $KillZone
@onready var muted_icon := $MutedIcon

@onready var ball_origin = Vector2(593.0, 683.0)
@onready var paddle_origin = Vector2(593.0, 710.0)
@onready var brick_count = get_tree().get_nodes_in_group("bricks").size()

@onready var is_muted: bool = false
@onready var muted_font_color: Color = Color.DARK_RED

var row_data = [
		[Color.RED, 1280],
		[Color.ORANGE_RED, 640],
		[Color.ORANGE, 320],
		[Color.YELLOW, 160],
		[Color.GREEN_YELLOW, 80],
		[Color.LIME_GREEN, 40],
		[Color.DEEP_SKY_BLUE, 20],
		[Color.ROYAL_BLUE, 10]
]

func _ready() -> void:
	hud.get_child(0).text += str(score)
	hud.get_child(1).text += str(level)
	hud.get_child(2).text += str(lives)
	_spawn_bricks()
	_spawn_ball()
	paddle.position = paddle_origin
	ceiling.connect("body_entered", _on_ceiling_body_entered)
	kill_zone.connect("body_entered", _on_kill_zone_body_entered)
	timer.connect("timeout", _on_timer_timeout)
	get_parent().connect("music_stopped", _on_music_stopped)
	get_parent().connect("music_started", _on_music_started)

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name.contains("Ball"):
		if lives > 1:
			lives -= 1
			hud.get_child(2).text = "Lives: %s" % str(lives)
			ball_entered_killzone.emit()
			body.queue_free()
			get_tree().paused = true
			timer.start()
			paddle.position = paddle_origin
		else:
			level_game_over.emit(score)

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
	ball.hit_paddle.connect(_on_ball_hit_paddle)
	ball.hit_wall.connect(_on_ball_hit_wall)
	
func _spawn_bricks():
	var start_row = row_data.size() - rows
	
	for row in rows:
		for col in columns:
			var brick = brick_scene.instantiate()
			brick.color = row_data[start_row + row][0]
			brick.points = row_data[start_row+ row][1]
			var x = start_pos.x + col * (brick_size.x + spacing.x)
			var y = start_pos.y + row * (brick_size.y + spacing.y)
			brick.position = Vector2(x, y)
			add_child(brick)

func _on_ball_hit_brick(brick) -> void:
	score += brick.points
	hud.get_child(0).text = "Score: %s" % str(score)
	if _get_brick_count() == 0:
		brick.destroy()
		_change_to_main_menu()
	ball_hit_brick.emit()
	brick.destroy()

func _on_ceiling_body_entered(body: Node2D) -> void:
	if body.name.contains("Ball"):
		ball_broke_out.emit(score)

func _on_ball_hit_paddle() -> void:
	ball_hit_paddle.emit()

func _on_ball_hit_wall() -> void:
	ball_hit_wall.emit()

func _on_music_stopped() -> void:
	$MutedIcon.show()

func _on_music_started() -> void:
	$MutedIcon.hide()
	
func _set_player_high_score(_score: int) -> void:
	if _score > Global.player_high_score:
		Global.player_high_score = _score
