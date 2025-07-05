extends Node2D

@onready var game_manager := get_parent()

func _ready() -> void:
	game_manager.scale_for_resolution(self)

func _on_return_button_pressed() -> void:
	game_manager.change_screen("menu_screen")
