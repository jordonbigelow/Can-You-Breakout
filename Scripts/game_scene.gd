extends Node2D

signal game_over

@onready var ball_scene: PackedScene = preload("res://Scenes/ball.tscn")
@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")

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

func _ready() -> void:
	level1 = level1_scene.instantiate()
	level2 = level2_scene.instantiate()
	level3 = level3_scene.instantiate()
	level4 = level4_scene.instantiate()
	
	current_level = level1
	
	levels.append(level1)
	levels.append(level2)
	levels.append(level3)
	levels.append(level4)
	
	for level in levels:
		level.game_over.connect(_on_game_over)
		level.ball_entered_killzone.connect(_on_level_ball_entered_killzone)
		level.ball_broke_out.connect(_on_level_ball_broke_out)
		
	add_child(current_level)

func _change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_game_over() -> void:
	_change_to_main_menu()

func _on_level_game_over() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_level_ball_entered_killzone() -> void:
	print("you died")

func _on_level_ball_broke_out(score: int) -> void:
	prints("Score:", score)
	_switch_level(current_level)

func _switch_level(level: Node) -> void:
	if level == level1:
		remove_child(current_level)
		current_level = level2
		add_child(current_level)
		#get_tree().change_scene_to_packed(level2_scene)
	elif level == level2:
		remove_child(current_level)
		current_level = level3
		add_child(current_level)
		#get_tree().change_scene_to_packed(level3_scene)
	elif level == level3:
		remove_child(current_level)
		current_level = level4
		add_child(current_level)
		#get_tree().change_scene_to_packed(level4_scene)
	elif level == level4:
		get_tree().change_scene_to_packed(main_menu_scene)
