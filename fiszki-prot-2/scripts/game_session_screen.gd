extends Node2D

@onready var game_manager := get_parent()
@onready var words_library_path := "res://assets/words_library.json"
@onready var category_label := $CategoryLabel
@onready var languages_label := $LanguagesLabel
@onready var words_number_label := $WordsNumberLabel
@onready var sorting_label := $SortingLabel
@onready var flashcard_button: Button = $FlashCardButton
@onready var flashcard_label := $FlashCardButton/RichTextLabel
@onready var hint_label := $HintButton/RichTextLabel
@onready var difficulty_color := $DifficultyButton/ColorRect
@onready var difficulty_label := $DifficultyButton/RichTextLabel

# Variables for rotating the fishcard
var is_rotating = false
var rotation_time: float = 0.1
var rotation_elapsed: float = 0.0
var count_language_switch: int = 0
var can_switch_language: bool = false
var difficulty: String = "Trudne"

# Variables for fishcards
var actual_fishcard_index: int = 0
var count_hints: int = 0
var updated_difficulties: Array = []

func _ready() -> void:
	print(game_manager.category_to_learn)
	set_labels()
	game_manager.scale_for_resolution(self)
	game_manager.shuffle_array_of_words()
	updated_difficulties.clear()
	for word in game_manager.array_of_words:
		updated_difficulties.append([word[2], word[3]])

func set_labels() -> void:
	category_label.text += game_manager.category_to_learn
	languages_label.text += game_manager.language_one
	languages_label.text += " i "
	languages_label.text += game_manager.language_two
	words_number_label.text += str(game_manager.number_of_cards)
	sorting_label.text += game_manager.sorting_type


func _process(delta: float) -> void:
	
	# ROTATION
	if is_rotating:
		rotation_elapsed += delta
		var t = rotation_elapsed / (rotation_time / 2)
		if t <= 1.0:
			flashcard_button.scale.x = lerp(1.0, 0.0, t)
		elif t <= 2.0:
			var t2 = t - 1.
			flashcard_button.scale.x = lerp(0.0, 1.0, t2)
			if can_switch_language:
				can_switch_language = false
				count_language_switch += 1
		else:
			is_rotating = false
			flashcard_button. disabled = false
	
	# FLASHCARD TEXT
	if game_manager.array_of_words.size() > 0:
		if bool(count_language_switch % 2):
			flashcard_label.text = game_manager.array_of_words[actual_fishcard_index][1]
		else:
			flashcard_label.text = game_manager.array_of_words[actual_fishcard_index][0]
	else:
		flashcard_label.text = "Brak fiszek"
	
	# FLASHCARD DIFFICULTY
	difficulty = game_manager.array_of_words[actual_fishcard_index][3]
	difficulty_label.text = "Trudność fiszek: " + difficulty
	if difficulty == "Łatwe":
		difficulty_color.color = game_manager.color_easy
		difficulty_label.text = "Trudność fiszek: Łatwe"
	if difficulty == "Średnie":
		difficulty_color.color = game_manager.color_medium
		difficulty_label.text = "Trudność fiszek: Średnie"
	if difficulty == "Trudne":
		difficulty_color.color = game_manager.color_hard
		difficulty_label.text = "Trudność fiszek: Trudne"
	for i in range(updated_difficulties.size()):
		if updated_difficulties[i][0] == game_manager.array_of_words[actual_fishcard_index][2]:
			updated_difficulties[i][1] = difficulty
			break

func _on_flash_card_button_pressed() -> void:
	# The flashcard is rotating in _process, so here we just start proces
	if not is_rotating:
		flashcard_button.pivot_offset = flashcard_button.size / 2
		is_rotating = true
		can_switch_language = true
		rotation_elapsed = 0.0
		flashcard_button.disabled = true


func _on_hint_button_pressed() -> void:
	if count_hints < game_manager.array_of_words[actual_fishcard_index][1].length():
		hint_label.text += game_manager.array_of_words[actual_fishcard_index][1][count_hints]
		count_hints += 1


func _on_difficulty_button_pressed() -> void:
	
	if difficulty == "Łatwe":
		difficulty = "Średnie"
		game_manager.array_of_words[actual_fishcard_index][3] = "Średnie"
	elif difficulty == "Średnie":
		difficulty = "Trudne"
		game_manager.array_of_words[actual_fishcard_index][3] = "Trudne"
	elif difficulty == "Trudne":
		difficulty = "Łatwe"
		game_manager.array_of_words[actual_fishcard_index][3] = "Łatwe"


func _on_repeat_button_pressed() -> void:
	if actual_fishcard_index == game_manager.array_of_words.size() - 1:
		actual_fishcard_index = 0
	else:
		actual_fishcard_index += 1
	count_language_switch = 0
	count_hints = 0
	hint_label.text = "Podpowiedź: "

func _on_throw_out_button_pressed() -> void:
	# Remove the flashcard
	game_manager.array_of_words.remove_at(actual_fishcard_index)
	if actual_fishcard_index == game_manager.array_of_words.size() - 1:
		actual_fishcard_index = 0
	words_number_label.text = "Liczba fiszek: "
	game_manager.number_of_cards -= 1
	words_number_label.text += str(game_manager.number_of_cards)
	count_language_switch = 0
	count_hints = 0
	hint_label.text = "Podpowiedź: "
	if game_manager.number_of_cards < 1:
		print("KONIEC SESJI")
		print(updated_difficulties)
		save_difficulty_changes()
		game_manager.change_screen("menu_screen")

func save_difficulty_changes():
	# Otwórz plik JSON
	var file = FileAccess.open(words_library_path, FileAccess.READ)
	if not file:
		print("Nie można otworzyć pliku JSON do odczytu.")
		return
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_ARRAY:
		print("Nieprawidłowy format JSON.")
		return

	# Aktualizuj difficulty w data według updated_difficulties
	for entry in data:
		if entry.has("id"):
			var entry_id = entry["id"]
			for update in updated_difficulties:
				if update[0] == entry_id:
					entry["difficulty"] = update[1]
					break

	# Zapisz zmieniony JSON do pliku
	file = FileAccess.open(words_library_path, FileAccess.WRITE)
	if not file:
		print("Nie można otworzyć pliku JSON do zapisu.")
		return
	file.store_string(JSON.stringify(data, "\t")) # \t dla czytelności
	file.close()
