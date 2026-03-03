extends CenterContainer

@onready var popup_settings_menu := $SettingsMenu
@onready var resume_button := $VBoxContainer/ResumeButton
@onready var main_menu_button := $VBoxContainer/MainMenuButton
@onready var settings_button := $VBoxContainer/SettingsButton
@onready var main_menu_scene: PackedScene = load("res://Scenes/main_menu.tscn")

func _ready() -> void:
	resume_button.connect("pressed", _on_resume_button_pressed)
	main_menu_button.connect("pressed", _on_main_menu_button_pressed)
	settings_button.connect("pressed", _on_settings_button_pressed)

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	_change_to_main_menu()

func _on_settings_button_pressed() -> void:
	popup_settings_menu.visible = true

func _change_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
