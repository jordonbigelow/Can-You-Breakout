extends Control

@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
