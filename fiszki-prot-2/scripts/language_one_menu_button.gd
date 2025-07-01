extends MenuButton

func generate_languages_menu(languages: Array) -> void:
	var popup = get_popup()
	popup.clear()
	
	for i in languages.size():
		var lang = languages[i]
		popup.add_item(lang.capitalize(), i)

	popup.connect("id_pressed", Callable(self, "_on_language_selected"))

func _on_language_selected(id: int) -> void:
	var lang = get_popup().get_item_text(id)
	text = lang.capitalize()
	print("Wybrano język:", lang)
