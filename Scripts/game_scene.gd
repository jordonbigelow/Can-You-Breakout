extends Node2D

signal music_stopped
signal music_started

@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")

@onready var pause_menu_scene: PackedScene = preload("res://Scenes/pause_menu.tscn")

@onready var level1_scene: PackedScene = preload("res://Scenes/level1.tscn")
@onready var level2_scene: PackedScene = preload("res://Scenes/level2.tscn")
@onready var level3_scene: PackedScene = preload("res://Scenes/level3.tscn")
@onready var level4_scene: PackedScene = preload("res://Scenes/level4.tscn")
@onready var level1: Node
@onready var level2: Node
@onready var level3: Node
@onready var level4: Node
@onready var levels: Array[Node]
@onready var current_level
@onready var current_score: int

@onready var pause_menu := $CanvasLayer/PauseMenu

@onready var sound_effects := $SoundEffects
@onready var music := $Music

@onready var is_muted: bool = false

func _ready() -> void:
	sound_effects.connect("finished", _on_sound_effects_finished)
	level1 = level1_scene.instantiate()
	level2 = level2_scene.instantiate()
	level3 = level3_scene.instantiate()
	level4 = level4_scene.instantiate()
	levels.append(level1)
	levels.append(level2)
	levels.append(level3)
	levels.append(level4)
	current_level = level1
	
	for level in levels:
		level.level_game_over.connect(_on_level_game_over)
		level.ball_entered_killzone.connect(_on_level_ball_entered_killzone)
		level.ball_broke_out.connect(_on_level_ball_broke_out)
		level.ball_hit_brick.connect(_on_level_ball_hit_brick)
		level.ball_hit_wall.connect(_on_level_ball_hit_wall)
		level.ball_hit_paddle.connect(_on_level_ball_hit_paddle)
		
	add_child(current_level)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.show()
		get_tree().paused = true

	if Input.is_action_just_pressed("mute_sound"):
		if !is_muted:
			is_muted = true
			music.stop()
			music_stopped.emit()
		else:
			is_muted = false
			music.play()
			music_started.emit()

func _on_level_game_over(_score: int) -> void:
	if _score > Global.player_high_score:
		Global.player_high_score = _score
	_change_to_main_menu.call_deferred()

func _on_level_ball_entered_killzone() -> void:
	print("you died")

func _on_level_ball_broke_out(_score: int) -> void:
	current_score += _score
	_switch_level.call_deferred()

func _on_level_ball_hit_brick() -> void:
	sound_effects.play(0.25)

func _switch_level() -> void:
	if current_level == level1:
		remove_child(current_level)
		current_level = level2
		current_level.score = current_score
		add_child(current_level)
	elif current_level == level2:
		remove_child(current_level)
		current_level = level3
		current_level.score = current_score
		add_child(current_level)
	elif current_level == level3:
		remove_child(current_level)
		current_level = level4
		current_level.score = current_score
		add_child(current_level)
	elif current_level == level4:
		current_level.score = current_score
		_change_to_main_menu.call_deferred()

func _on_level_ball_hit_wall() -> void:
	sound_effects.play(0.25)

func _on_level_ball_hit_paddle() -> void:
	sound_effects.pitch_scale *= 1.2
	sound_effects.play(0.25)

func _on_sound_effects_finished() -> void:
	sound_effects.pitch_scale = 1.0

func _change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
