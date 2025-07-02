extends MenuButton

@onready var game_manager = get_node("/root/GameManager")

func generate_languages_menu(languages: Array) -> void:
	var popup = get_popup()
	popup.clear()
	
	for i in languages.size():
		var lang = languages[i]
		popup.add_item(lang, i)

	popup.connect("id_pressed", Callable(self, "_on_language_selected"))

func _on_language_selected(id: int) -> void:
	var lang = get_popup().get_item_text(id)
	text = lang
	game_manager.language_one = lang
	print("Wybrano język: ", lang)
	
