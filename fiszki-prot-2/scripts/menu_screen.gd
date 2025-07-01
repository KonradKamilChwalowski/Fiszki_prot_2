extends Node2D

@onready var game_manager := get_parent()

func _on_start_button_pressed() -> void:
	game_manager.change_screen("language_choice_screen")

func _on_library_button_pressed() -> void:
	game_manager.change_screen("library_screen")

func _on_options_button_pressed() -> void:
	game_manager.change_screen("options_screen")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
