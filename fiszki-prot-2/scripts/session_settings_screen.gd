extends Node2D

@onready var game_manager := get_parent()
@onready var words_library_path := "res://assets/words_library.json"
@onready var category_label := $CategoryLabel
@onready var languages_label := $LanguagesLabel
@onready var words_number_label := $WordsNumberLabel
@onready var number_label := $NumberButton/RichTextLabel
@onready var sorting_label := $SortingButton/RichTextLabel
@onready var difficulty_label := $DifficultyButton/RichTextLabel
@onready var difficulty_color := $DifficultyButton/ColorRect

var number_of_cards = 1000
var sorting_type: String = "Alfabetycznie"
var difficulty: String = "Wszystkie"

func _ready() -> void:
	set_labels()
	difficulty_color.color = game_manager.color_all
	game_manager.scale_for_resolution(self)

func set_labels() -> void:
	category_label.text += game_manager.category_to_learn
	languages_label.text += game_manager.language_one
	languages_label.text += " i "
	languages_label.text += game_manager.language_two
	words_number_label.text += str(count_words_in_category(game_manager.category_to_learn))

func count_words_in_category(category_name: String) -> int:
	# JSON
	var file = FileAccess.open(words_library_path, FileAccess.READ)
	if not file:
		print("Nie można otworzyć pliku JSON.")
		return 0
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_ARRAY:
		print("Nieprawidłowy format JSON.")
		return 0

	var count = 0
	for entry in data:
		if entry.has("category") and entry["category"] == category_name:
			count += 1
	return count


func _on_number_button_pressed() -> void:
	var did_it_change: bool = false
	
	if number_of_cards == 10 and did_it_change == false:
		number_of_cards = 20
		number_label.text = "Liczba fiszek: 20"
		did_it_change = true
	if number_of_cards == 20 and did_it_change == false:
		number_of_cards = 30
		number_label.text = "Liczba fiszek: 30"
		did_it_change = true
	if number_of_cards == 30 and did_it_change == false:
		number_of_cards = 45
		number_label.text = "Liczba fiszek: 45"
		did_it_change = true
	if number_of_cards == 45 and did_it_change == false:
		number_of_cards = 60
		number_label.text = "Liczba fiszek: 60"
		did_it_change = true
	if number_of_cards == 60 and did_it_change == false:
		number_of_cards = 1000
		number_label.text = "Liczba fiszek: Wszystkie"
		did_it_change = true
	if number_of_cards == 1000 and did_it_change == false:
		number_of_cards = 10
		number_label.text = "Liczba fiszek: 10"
		did_it_change = true

func _on_sorting_button_pressed() -> void:
	var did_it_change: bool = false
	
	if sorting_type == "Alfabetycznie" and did_it_change == false:
		sorting_type = "Losowo"
		sorting_label.text = "Wyświetlanie: Losowo"
		did_it_change = true
	if sorting_type == "Losowo" and did_it_change == false:
		sorting_type = "id"
		sorting_label.text = "Wyświetlanie: Po ID fiszki"
		did_it_change = true
	if sorting_type == "id" and did_it_change == false:
		sorting_type = "Alfabetycznie"
		sorting_label.text = "Wyświetlanie: Alfabetycznie"
		did_it_change = true

func _on_difficulty_button_pressed() -> void:
	
	if difficulty == "Łatwe":
		difficulty = "Średnie"
		difficulty_label.text = "Trudność fiszek: Średnie"
		difficulty_color.color = game_manager.color_medium
	elif difficulty == "Średnie":
		difficulty = "Trudne"
		difficulty_label.text = "Trudność fiszek: Trudne"
		difficulty_color.color = game_manager.color_hard
	elif difficulty == "Trudne":
		difficulty = "Wszystkie"
		difficulty_label.text = "Trudność fiszek: Wszystkie"
		difficulty_color.color = game_manager.color_all
	elif difficulty == "Wszystkie":
		difficulty = "Łatwe"
		difficulty_label.text = "Trudność fiszek: Łatwe"
		difficulty_color.color = game_manager.color_easy

func _on_return_button_pressed() -> void:
	game_manager.change_screen("language_choice_screen")

func _on_next_button_pressed() -> void:
	ready_session()
	game_manager.change_screen("game_session_screen")

func ready_session() -> void:
	game_manager.sorting_type = sorting_type
	game_manager.difficulty = difficulty
	
	# JSON
	var file = FileAccess.open(words_library_path, FileAccess.READ)
	if not file:
		print("Nie można otworzyć pliku: ", words_library_path)
		return
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_ARRAY:
		print("Nieprawidłowy format JSON.")
		return
	
	# Loading words to arrays
	game_manager.array_of_words.clear()
	var bool_lang_one: bool
	var bool_lang_two: bool
	var bool_difficulty: bool
	var bool_category: bool
	for entry in data:
		bool_lang_one = entry.has(game_manager.language_one)
		bool_lang_two = entry.has(game_manager.language_two)
		bool_category = (entry.has("difficulty") and entry["category"] == game_manager.category_to_learn)
		if difficulty == "Wszystkie":
			bool_difficulty = true
		else:
			bool_difficulty = (entry.has("difficulty") and entry["difficulty"] == difficulty)
		
		if bool_lang_one and bool_lang_two and bool_difficulty and bool_category:
			game_manager.array_of_words.append([entry[game_manager.language_one],entry[game_manager.language_two], int(entry["id"]), entry["difficulty"]])
	
	# Cutting arrays to number_of_cards lenght
	if number_of_cards >= game_manager.array_of_words.size():
		game_manager.number_of_cards = game_manager.array_of_words.size()
		return
	while game_manager.array_of_words.size() > number_of_cards:
		var index_to_remove = randi() % game_manager.array_of_words.size()
		game_manager.array_of_words.remove_at(index_to_remove)
	game_manager.number_of_cards = game_manager.array_of_words.size()
	print(game_manager.array_of_words)
