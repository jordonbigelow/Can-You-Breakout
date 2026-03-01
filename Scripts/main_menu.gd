extends Control

@onready var game_scene: PackedScene = load("res://Scenes/game_scene.tscn")
@onready var settings_scene: PackedScene = load("res://Scenes/settings_menu.tscn")
@onready var click_sound := $SoundEffects

func _on_play_button_pressed() -> void:
	click_sound.play(0.89)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_packed(game_scene)


func _on_settings_button_pressed() -> void:
	click_sound.play(0.89)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_packed(settings_scene)
