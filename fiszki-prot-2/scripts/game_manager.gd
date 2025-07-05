extends Node2D

@onready var background: ColorRect = $ColorRect

# SCREENS
var menu_screen := load("res://screens/menu_screen.tscn")
var language_choice_screen := load("res://screens/language_choice_screen.tscn")
var library_screen := load("res://screens/library_screen.tscn")
var options_screen := load("res://screens/options_screen.tscn")
var session_settings_screen := load("res://screens/session_settings_screen.tscn")
var game_session_screen := load("res://screens/game_session_screen.tscn")
var actual_screen: Node2D

# LANGUAGE SETTINGS
var all_languages:= ["polish", "english", "ukrainian", "german", "spanish"]
var special_categories := {
	"alfabet ukraiński": ["polish", "ukrainian"]
}

# SESSION SETTINGS
var category_to_learn: String
var language_one: String
var language_two: String
var number_of_cards: int = 10
var sorting_type: String = "Alfabetycznie"
var difficulty: String = "Wszystkie"

# VARIABLES
var array_of_words: Array = []
var color_easy: Color = Color(0.0, 0.6, 0.0, 0.6)
var color_medium: Color = Color(0.6, 0.6, 0.0, 0.6)
var color_hard: Color = Color(0.6, 0.0, 0.0, 0.6)
var color_all: Color = Color(0.4, 0.4, 0.4, 0.6)
var screen_resolutions: Array = [[360, 640, 1.0], [540, 960, 1.5], [720, 1280, 2.0], [1080, 1920, 3.0]]
var actual_resolution_index: int = 2

func _ready() -> void:
	# WINDOW RESOLUTION
	DisplayServer.window_set_size(Vector2i(screen_resolutions[actual_resolution_index][0], screen_resolutions[actual_resolution_index][1]))
	background.scale = Vector2(screen_resolutions[actual_resolution_index][2], screen_resolutions[actual_resolution_index][2])
	# SCREEN
	actual_screen = menu_screen.instantiate()
	add_child(actual_screen)

func scale_for_resolution(scene: Node2D) -> void:
	# WINDOW RESOLUTION
	DisplayServer.window_set_size(Vector2i(screen_resolutions[actual_resolution_index][0], screen_resolutions[actual_resolution_index][1]))
	background.scale = Vector2(screen_resolutions[actual_resolution_index][2], screen_resolutions[actual_resolution_index][2])
	# ALL OTHER RESOLUTION
	for child in scene.get_children():
		child.position *= screen_resolutions[actual_resolution_index][2]
		child.size *= screen_resolutions[actual_resolution_index][2]
		for grandchild in child.get_children():
			if grandchild is RichTextLabel:
				grandchild.add_theme_font_size_override("normal_font_size", screen_resolutions[actual_resolution_index][2] * 16)

func shuffle_array_of_words() -> void:
	if sorting_type == "Alfabetycznie":
		array_of_words.sort_custom(func(a, b):
			return a[0] < b[0])
	if sorting_type == "Losowo":
		for word_index in range(array_of_words.size()):
			var rand_index = randi() % array_of_words.size()
			var temp = array_of_words[word_index]
			array_of_words[word_index] = array_of_words[rand_index]
			array_of_words[rand_index] = temp
	if sorting_type == "id":
		array_of_words.sort_custom(func(a, b):
			return a[2] < b[2])

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
		
	if screen_name == "session_settings_screen":
		actual_screen = session_settings_screen.instantiate()
		
	if screen_name == "game_session_screen":
		actual_screen = game_session_screen.instantiate()
	
	add_child(actual_screen)
