extends Node2D

@onready var game_manager := get_parent()
@onready var logo_texture: TextureRect = $EasterEggButton/Logo

var is_rotating: bool = false
var easter_egg_counter: int = 0
var rotation_elapsed: float = 0.0

func _ready() -> void:
	game_manager.scale_for_resolution(self)

func _process(delta: float) -> void:
	# ROTATION
	if is_rotating:
		rotation_elapsed += delta
		var t = rotation_elapsed / (0.4)
		if t <= 1.0:
			logo_texture.scale.x = lerp(1.0, 0.0, t)
		elif t <= 2.0:
			logo_texture.texture = load("res://assets/Logo_face.png")
			var t2 = t - 1.
			logo_texture.scale.x = lerp(0.0, 1.0, t2)
		else:
			is_rotating = false

func _on_start_button_pressed() -> void:
	game_manager.change_screen("language_choice_screen")

func _on_library_button_pressed() -> void:
	game_manager.change_screen("library_screen")

func _on_options_button_pressed() -> void:
	game_manager.change_screen("options_screen")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_easter_egg_button_pressed() -> void:
	# The flashcard is rotating in _process, so here we just start proces
	easter_egg_counter += 1
	if not is_rotating and easter_egg_counter == 5:
		logo_texture.pivot_offset = logo_texture.size / 2
		is_rotating = true
		rotation_elapsed = 0.0
