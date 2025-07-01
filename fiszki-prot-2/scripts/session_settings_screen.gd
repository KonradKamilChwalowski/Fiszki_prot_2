extends Node2D

@onready var game_manager := get_parent()
@onready var words_library_path := "res://assets/words_library.json"
@onready var category_label := $CategoryLabel
@onready var languages_label := $LanguagesLabel
@onready var words_number_label := $WordsNumberLabel

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


func _on_return_button_pressed() -> void:
	game_manager.change_screen("language_choice_screen")


func _on_next_button_pressed() -> void:
	game_manager.change_screen("game_session_screen")
