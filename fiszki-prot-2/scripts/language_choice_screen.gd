extends Node2D

@onready var game_manager := get_parent()

func _on_return_button_pressed() -> void:
	game_manager.change_screen("menu_screen")


func _on_next_button_pressed() -> void:
	#game_manager.change_screen("session_settings_screen")
	pass # Replace with function body.
