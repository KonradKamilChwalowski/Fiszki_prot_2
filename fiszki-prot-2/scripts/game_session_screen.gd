extends Node2D

@onready var game_manager := get_parent()
@onready var words_library_path := "res://assets/words_library.json"
@onready var category_label := $CategoryLabel
@onready var languages_label := $LanguagesLabel
@onready var words_number_label := $WordsNumberLabel
@onready var difficulty_label := $DifficultyLabel
@onready var flashcard_button: Button = $FlashCardButton
@onready var flashcard_label := $FlashCardButton/RichTextLabel

var is_rotating = false
var rotation_time: float = 0.1
var rotation_elapsed: float = 0.0
var count_language_switch: int = 0
var can_switch_language: bool = false

func _ready() -> void:
	print(game_manager.category_to_learn)
	set_labels()
	if game_manager.sorting_type == "Losowo":
		shuffle_array_of_words()

func set_labels() -> void:
	category_label.text += game_manager.category_to_learn
	languages_label.text += game_manager.language_one
	languages_label.text += " i "
	languages_label.text += game_manager.language_two
	words_number_label.text += str(game_manager.number_of_cards)
	difficulty_label.text += game_manager.difficulty


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
			flashcard_label.text = game_manager.array_of_words[0][1]
		else:
			flashcard_label.text = game_manager.array_of_words[0][0]
	else:
		flashcard_label.text = "Brak fiszek"

func _on_flash_card_button_pressed() -> void:
	if not is_rotating:
		is_rotating = true
		can_switch_language = true
		rotation_elapsed = 0.0
		flashcard_button.disabled = true

func shuffle_array_of_words() -> void:
	for word_index in range(game_manager.array_of_words.size()):
		var rand_index = randi() % game_manager.array_of_words.size()
		var temp = game_manager.array_of_words[word_index]
		game_manager.array_of_words[word_index] = game_manager.array_of_words[rand_index]
		game_manager.array_of_words[rand_index] = temp

func _on_hint_button_pressed() -> void:
	pass # Replace with function body.


func _on_difficulty_button_pressed() -> void:
	pass # Replace with function body.


func _on_repeat_button_pressed() -> void:
	pass # Replace with function body.


func _on_throw_out_button_pressed() -> void:
	pass # Replace with function body.
