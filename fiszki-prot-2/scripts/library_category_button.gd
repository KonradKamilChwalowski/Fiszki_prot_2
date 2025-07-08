extends MenuButton

@onready var game_manager = get_node("/root/GameManager")
@onready var words_library_path := "res://assets/languages_words_library.json"
@onready var all_languages: Array = game_manager.all_languages
@onready var special_categories: Dictionary = game_manager.special_categories
@onready var box_container: VBoxContainer = $"../ScrollContainer/VBoxContainer"

var categories_tab: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var categories: Array = list_categories()
	create_menu_options(categories)
	get_popup().connect("id_pressed", Callable(self, "_on_category_selected"))
	self.add_theme_font_size_override("font_size", game_manager.screen_resolutions[game_manager.actual_resolution_index][2] * 16)

# lists categories from JSON
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
	
	# Loading words to array
	game_manager.array_of_words.clear()
	for entry in data:
		game_manager.array_of_words.append(entry)
	
	return categories_array

func create_menu_options(categories: Array) -> void:
	var popup = get_popup()
	popup.clear()
	
	for i in categories.size():
		popup.add_item(categories[i], i)
		popup.add_theme_font_size_override("font_size", game_manager.screen_resolutions[game_manager.actual_resolution_index][2] * 16)
	
	categories.sort_custom(func(a, b):
			return a[0] < b[0])

# Obsługa wyboru kategorii
func _on_category_selected(id: int) -> void:
	text = categories_tab[id]
	box_container.visible = true
	for child in box_container.get_children():
		child.queue_free()
	
	for entry in game_manager.array_of_words:
		if entry["category"] == categories_tab[id]:
			var button: Button = Button.new()
			var entry_id: int = (int(entry["id"]) % 1000) + 1
			button.text = str(entry_id) + ". " + entry["polish"]
			#button.connect("pressed", Callable(self, "_on_word_button_pressed").bind(entry))
			var scale_factor = game_manager.screen_resolutions[game_manager.actual_resolution_index][2]
			button.custom_minimum_size.y = 40 * scale_factor
			button.add_theme_font_size_override("font_size", scale_factor * 16)
			box_container.add_child(button)
