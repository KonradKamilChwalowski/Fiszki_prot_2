extends MenuButton

@onready var game_manager = get_node("/root/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_menu_options(game_manager.screen_resolutions)
	get_popup().connect("id_pressed", Callable(self, "_on_category_selected"))
	self.add_theme_font_size_override("font_size", game_manager.screen_resolutions[game_manager.actual_resolution_index][2] * 16)

func create_menu_options(categories: Array) -> void:
	var popup = get_popup()
	popup.clear()
	
	for i in categories.size():
		popup.add_item(str(categories[i][0]) + " x " + str(categories[i][1]), i)
	
	categories.sort_custom(func(a, b):
			return a[0] < b[0])

func _on_category_selected(id: int) -> void:
	game_manager.actual_resolution_index = id
	text = str(game_manager.screen_resolutions[id][0]) + " x " + str(game_manager.screen_resolutions[id][1])
