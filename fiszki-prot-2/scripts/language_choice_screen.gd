extends Node2D

@onready var game_manager := get_parent()

var is_category_choosen: bool = false
var is_lang_one_choosen: bool = false
var is_lang_two_choosen: bool = false

func _on_return_button_pressed() -> void:
	game_manager.change_screen("menu_screen")


func _on_next_button_pressed() -> void:
	#game_manager.change_screen("session_settings_screen")
	#return
	if is_category_choosen and is_lang_one_choosen and is_lang_two_choosen:
		game_manager.change_screen("session_settings_screen")
	else:
		print("YOU NEED TO CHOOSE")
