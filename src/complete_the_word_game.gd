extends Node2D
class_name CompleteWordGame
signal word_completed

const UNDERSCORE = preload("res://scenes/underscore.tscn")
const MAX_WORD_POOL_SIZE = 18

var current_word: String = ""
var screen_size: Vector2 = Vector2.ZERO

var answer_slot: Array[String] = []
var slot_nodes: Array[Label] = []
var used_buttons: Array[Button] = []

var attemps = 0

func setup(word: String, new_screen_size: Vector2, sprite_texture: Texture2D = null) -> void:
	self.current_word = word
	self.screen_size = new_screen_size
	
	modulate.a = 0.0 # Magic number
	
	if sprite_texture:
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.position = Vector2(screen_size.x * 1.5, screen_size.y * 0.3)
		add_child(sprite)
		
	generate_words_pool(current_word)
	gen_text_underscore(current_word)
	create_check_button()
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
func create_check_button() -> void:
	var button = Button.new()
	button.text = "-->"

	button.position = Vector2(
		screen_size.x - 250, # Magic number
		screen_size.y - 120 # Magic number
	)
	button.add_theme_font_size_override("font_size", 32) # Magic number
	button.add_theme_color_override("font_color", Color(0.123, 0.118, 0.104, 1.0))
	button.size = Vector2(200,80) # Magic number

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.708, 0.348, 1.0)
	style.corner_radius_top_left = 12 # Magic number
	style.corner_radius_top_right = 12 # Magic number
	style.corner_radius_bottom_left = 12 # Magic number
	style.corner_radius_bottom_right = 12 # Magic number
	button.add_theme_stylebox_override("normal", style)

	add_child(button)

	button.pressed.connect(check_answer)

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			remove_last_letter()
			return

		if event.keycode == KEY_ENTER:
			check_answer()
			return

		var text = event.as_text().to_upper()

		if text.length() != 1: # Magic number
			return

		for child in get_children():
			if child is Button:
				if child.text == text and !child.disabled:
					_on_letter_pressed(child)
					break

func generate_words_pool(word: String) -> void:
	var word_pool: Array[String] = []

	for letter in word:
		word_pool.append(letter.to_upper())

	var alphabet = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

	while word_pool.size() < MAX_WORD_POOL_SIZE:
		var random_letter = alphabet[randi() % alphabet.length()]
		if not word_pool.has(random_letter):
			word_pool.append(random_letter)

	word_pool.shuffle()

	for i in range(word_pool.size()):
		create_letter_button(word_pool[i], i)

func gen_text_underscore(word: String) -> void:
	var start_x = screen_size.x * 0.50 # Magic number
	var y = screen_size.y * 0.35 # Magic number
	var spacing = 80 # Magic number

	answer_slot.clear()
	slot_nodes.clear()

	for i in range(word.length()):
		answer_slot.append("")

		var my_asset = UNDERSCORE.instantiate()
		my_asset.position = Vector2(start_x + i * spacing, y)
		add_child(my_asset)

		var label = Label.new()
		label.text = "_"
		label.position = Vector2(start_x + i * spacing, y - 70)
		label.add_theme_font_size_override("font_size", 48)
		add_child(label)

		slot_nodes.append(label)

func create_letter_button(letter: String, index: int) -> void:
	var button = Button.new()
	button.text = letter.to_upper()
	button.position = Vector2(
		screen_size.x * 0.50 + (index % 6) * 100, # Magic number
		screen_size.y * 0.50 + int(index / 6) * 80 # Magic number
	)

	button.add_theme_font_size_override("font_size", 32) # Magic number
	add_child(button)

	button.pressed.connect(func():
		_on_letter_pressed(button)
	)

func _on_letter_pressed(button: Button) -> void:
	var letter = button.text

	for i in range(answer_slot.size()):
		if answer_slot[i] == "":
			answer_slot[i] = letter
			slot_nodes[i].text = letter
			used_buttons.append(button)
			button.disabled = true
			break

func remove_last_letter() -> void:
	if used_buttons.is_empty():
		return

	for i in range(answer_slot.size() - 1, -1, -1):
		if answer_slot[i] != "":
			answer_slot[i] = ""
			slot_nodes[i].text = "_"

			var button = used_buttons.pop_back()
			button.disabled = false
			break

func check_answer() -> bool:
	var player_word = ""

	for letter in answer_slot:
		player_word += letter

	if player_word == current_word:
		word_completed.emit()
		return true

	attemps += 1 # Magic number
	
	if attemps >= 5: # Magic number
		complete_word()
		return true
	return false

func reveal_random_letter() -> void:
	pass

func complete_word() -> void:
	for i in range(current_word.length()):
		answer_slot[i] = current_word[i]
		slot_nodes[i].text = current_word[i]
	
	await get_tree().create_timer(1.5).timeout # Magic number
	word_completed.emit()
	
func incorrect_animation() -> void:
	pass
		
func correct_animation() -> void:
	pass
