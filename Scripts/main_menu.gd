extends Control

@onready var game_scene: PackedScene = load("res://Scenes/game_scene.tscn")


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
