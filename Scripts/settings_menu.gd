extends Control

@onready var click_sound = $AudioStreamPlayer

func _on_back_button_pressed() -> void:
	_play_sound_and_wait()
	visible = false

func _play_sound_and_wait() -> void:
	click_sound.play(0.89)
	await get_tree().create_timer(0.8).timeout

func _on_master_mute_button_pressed() -> void:
	pass # Replace with function body.

func _on_music_mute_buttom_pressed() -> void:
	pass # Replace with function body.

func _on_sound_effects_mute_buttom_pressed() -> void:
	pass # Replace with function body.
