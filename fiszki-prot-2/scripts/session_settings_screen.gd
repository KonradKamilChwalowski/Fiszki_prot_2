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

var number_of_cards = 10
var sorting_type: String = "Alfabetycznie"
var difficulty: String = "Wszystkie"

func _ready() -> void:
	category_label.text += game_manager.category_to_learn
	languages_label.text += game_manager.language_one
	languages_label.text += " i "
	languages_label.text += game_manager.language_two
	words_number_label.text += str(count_words_in_category(game_manager.category_to_learn))
	
func count_words_in_category(category_name: String) -> int:
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
		number_of_cards = 10
		number_label.text = "Liczba fiszek: 10"
		did_it_change = true

func _on_sorting_button_pressed() -> void:
	var did_it_change: bool = false
	
	if sorting_type == "Alfabetycznie" and did_it_change == false:
		sorting_type = "Losowo"
		sorting_label.text = "Losowanie: Losowo"
		did_it_change = true
	if sorting_type == "Losowo" and did_it_change == false:
		sorting_type = "Alfabetycznie"
		sorting_label.text = "Losowanie: Alfabetycznie"
		did_it_change = true

func _on_difficulty_button_pressed() -> void:
	var did_it_change: bool = false
	
	if difficulty == "Łatwe" and did_it_change == false:
		difficulty = "Średnie"
		difficulty_label.text = "Trudność fiszek: Średnie"
		difficulty_color.color = Color(0.5, 0.5, 0.0, 0.6)
		did_it_change = true
	if difficulty == "Średnie" and did_it_change == false:
		difficulty = "Trudne"
		difficulty_label.text = "Trudność fiszek: Trudne"
		difficulty_color.color = Color(0.5, 0.0, 0.0, 0.6)
		did_it_change = true
	if difficulty == "Trudne" and did_it_change == false:
		difficulty = "Wszystkie"
		difficulty_label.text = "Trudność fiszek: Wszystkie"
		difficulty_color.color = Color(0.30, 0.30, 0.30, 0.6)
		did_it_change = true
	if difficulty == "Wszystkie" and did_it_change == false:
		difficulty = "Łatwe"
		difficulty_label.text = "Trudność fiszek: Łatwe"
		difficulty_color.color = Color(0.0, 0.5, 0.0, 0.6)
		did_it_change = true

func _on_return_button_pressed() -> void:
	game_manager.change_screen("language_choice_screen")

func _on_next_button_pressed() -> void:
	game_manager.number_of_cards = number_of_cards
	game_manager.sorting_type = sorting_type
	game_manager.difficulty = difficulty
	game_manager.change_screen("game_session_screen")
