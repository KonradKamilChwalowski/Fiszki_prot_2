extends MenuButton

@onready var game_manager = get_node("/root/GameManager")
@onready var words_library_path := "res://assets/words_library.json"
@onready var language_choice_screen := get_parent()
@onready var language_one_menu_button := $"../LanguageOneMenuButton"
@onready var language_two_menu_button := $"../LanguageTwoMenuButton"
@onready var all_languages: Array = game_manager.all_languages
@onready var special_categories: Dictionary = game_manager.special_categories

var categories_tab: Array = []

func _ready() -> void:
	var categories = list_categories()
	create_menu_options(categories)
	get_popup().connect("id_pressed", Callable(self, "_on_category_selected"))

# this funcion lists categories from JSON
func list_categories() -> Array:
	# JSON
	var file = FileAccess.open(words_library_path, FileAccess.READ)
	if not file:
		print("Nie można otworzyć pliku: ", words_library_path)
		return []
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_ARRAY:
		print("Nieprawidłowy format JSON.")
		return []

	var categories_set := {}
	for entry in data:
		if entry.has("category"):
			categories_set[entry["category"]] = true

	var categories_array = categories_set.keys()
	categories_array.sort()
	
	categories_tab = categories_array
	return categories_array

# 🔵 Funkcja 3. Tworzy opcje w menu
func create_menu_options(categories: Array) -> void:
	var popup = get_popup()
	popup.clear()
	
	for i in categories.size():
		popup.add_item(categories[i], i)
	
	categories.sort_custom(func(a, b):
			return a[0] < b[0])

# 🔵 Funkcja 4. Obsługa wyboru kategorii
func _on_category_selected(id: int) -> void:
	game_manager.category_to_learn = categories_tab[id]
	text = game_manager.category_to_learn
	var available_languages = check_category_languages(game_manager.category_to_learn)
	language_one_menu_button.generate_languages_menu(available_languages)
	language_one_menu_button.disabled = false
	language_one_menu_button.text = "Język pierwszy"
	language_two_menu_button.generate_languages_menu(available_languages)
	language_two_menu_button.disabled = false
	language_two_menu_button.text = "Język drugi"
	language_choice_screen.is_category_choosen = true
	language_choice_screen.is_lang_one_choosen = false
	language_choice_screen.is_lang_two_choosen = false

# 🔵 Funkcja 5. Sprawdza dostępne języki w kategorii
func check_category_languages(category: String) -> Array:
	if special_categories.has(category):
		return special_categories[category]
	else:
		return all_languages
