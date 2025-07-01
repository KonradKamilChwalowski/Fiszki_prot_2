extends Node2D

var menu_screen := load("res://screens/menu_screen.tscn")
var language_choice_screen := load("res://screens/language_choice_screen.tscn")
var library_screen := load("res://screens/library_screen.tscn")
var options_screen := load("res://screens/options_screen.tscn")
"""
var category_screen := load("res://screens/category_screen.tscn")
var game_session_screen := load("res://screens/game_session_screen.tscn")
"""
var actual_screen: Node2D

var language_to_learn: String
var category_to_learn: String

func _ready() -> void:
	actual_screen = menu_screen.instantiate()
	add_child(actual_screen)

func change_screen(screen_name: String) -> void:
	
	actual_screen.queue_free()
	
	if screen_name == "menu_screen":
		actual_screen = menu_screen.instantiate()
		
	if screen_name == "language_choice_screen":
		actual_screen = language_choice_screen.instantiate()
		
	if screen_name == "library_screen":
		actual_screen = library_screen.instantiate()
		
	if screen_name == "options_screen":
		actual_screen = options_screen.instantiate()
		
	"""if screen_name == "category_screen":
		actual_screen = category_screen.instantiate()
		
	if screen_name == "game_session_screen":
		actual_screen = game_session_screen.instantiate()"""
	
	add_child(actual_screen)
