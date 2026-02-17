extends Node2D

#signal game_over

#@export var brick_scene: PackedScene = load("res://Scenes/brick.tscn")
#@export var columns := 16
#@export var rows := 8
#@export var brick_size := Vector2(74, 15)
#@export var spacing := Vector2(4, 6)
#@export var start_pos := Vector2(20, 50)
#@export var lives: int = 3
#@onready var score: int = 0
#
#@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")
#
#@onready var paddle: CharacterBody2D = $Level/Paddle
#@onready var timer: Timer = $Level/Timer
#@onready var hud := $Level/UI/HUD/HBoxContainer
#@onready var pause_menu := $Level/PauseMenu
#@onready var sound_effects := $Level/SoundEffects
#
#@onready var ball_origin = Vector2(593.0, 683.0)
#@onready var paddle_origin = Vector2(593.0, 710.0)
#@onready var brick_count = get_tree().get_nodes_in_group("bricks").size()
#
@onready var level1: PackedScene = load("res://Scenes/level1.tscn")
@onready var level2: PackedScene = load("res://Scenes/level2.tscn")
@onready var level3: PackedScene = load("res://Scenes/level3.tscn")

func _ready() -> void:
	var level_as_node = level1.instantiate()
	level_as_node.ball_entered_killzone.connect(_on_level_ball_entered_killzone)
	level_as_node.game_over.connect(_on_level_game_over)
	level_as_node.ball_broke_out.connect(_on_level_ball_broke_out)
	add_child(level_as_node)

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("pause"):
		#get_tree().paused = true
		#pause_menu.show()
#
#func _on_kill_zone_body_entered(body: Node2D) -> void:
	#print(body)
	#if body.name.contains("Ball"):
		#if level.lives > 1:
			#level.lives -= 1
			#level.hud.get_child(1).text = "Lives: %s" % str(level.lives)
			#body.queue_free()
			#get_tree().paused = true
			#level.timer.start()
			#level.paddle.position = level.paddle_origin
		#else:
			#print("Game Over Score: ", level.score)
			#game_over.emit()
#
#func _on_timer_timeout() -> void:
	#get_tree().paused = false
	#level._spawn_ball()

#func _get_brick_count() -> int:
	#brick_count = get_tree().get_nodes_in_group("bricks").size()
	#return brick_count
	#
#func _change_to_main_menu() -> void:
	#get_tree().change_scene_to_packed(main_menu_scene)
#
#func _spawn_ball():
	#var ball = ball_scene.instantiate()
	#ball.position = ball_origin
	#add_child(ball)
	#ball.hit_brick.connect(_on_ball_hit_brick)
	#ball.hit_paddle.connect(_on_ball_hit_paddle)
	#ball.hit_wall.connect(_on_ball_hit_wall)
	#
#func _spawn_bricks():
	#for row in rows:
		#for col in columns:
			#var brick = brick_scene.instantiate()
			#if row == 0:
				#brick.color = Color.RED
				#brick.points = 20
			#elif row == 1:
				#brick.color = Color.ORANGE_RED
				#brick.points = 10
			#elif row == 2:
				#brick.color = Color.ORANGE
				#brick.points = 7
			#elif row == 3: 
				#brick.color = Color.YELLOW
				#brick.points = 5
			#elif row == 4:
				#brick.color = Color.GREEN_YELLOW
				#brick.points = 4
			#elif row == 5:
				#brick.color = Color.LIME_GREEN
				#brick.points = 3
			#elif row == 6: 
				#brick.color = Color.DEEP_SKY_BLUE
				#brick.points = 2
			#elif row == 7:
				#brick.color = Color.ROYAL_BLUE
				#brick.points = 1
			#var x = start_pos.x + col * (brick_size.x + spacing.x)
			#var y = start_pos.y + row * (brick_size.y + spacing.y)
			#brick.position = Vector2(x, y)
			#add_child(brick)
#
#func _on_ball_hit_brick(brick) -> void:
	#score += brick.points
	#hud.get_child(0).text = "Score: %s" % str(score)
	#if _get_brick_count() == 0:
		#print("you've won!")
		#brick.destroy()
		#_change_to_main_menu()
	#_play_sound_effects()
	#brick.destroy()
#
#func _on_ceiling_body_entered(body: Node2D) -> void:
	#if body.name.contains("Ball"):
		#print("you win")
		#game_over.emit()
#
#func _on_game_over() -> void:
	#_change_to_main_menu()
#
#func _on_resume_button_pressed() -> void:
	#get_tree().paused = false
	#pause_menu.hide()
#
#func _on_main_menu_button_pressed() -> void:
	#get_tree().paused = false
	#_change_to_main_menu()
#
#func _on_ball_hit_paddle() -> void:
	#sound_effects.pitch_scale *= 1.5
	#_play_sound_effects()
#
#func _on_ball_hit_wall() -> void:
	#_play_sound_effects()
#
#func _on_sound_effects_finished() -> void:
	#sound_effects.pitch_scale = 1.0
	#
#func _play_sound_effects() -> void:
	#sound_effects.play(0.25)
#

func _on_level_game_over() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_level_ball_entered_killzone() -> void:
	print("you died")

func _on_level_ball_broke_out() -> void:
	get_tree().change_scene_to_packed(level2)
