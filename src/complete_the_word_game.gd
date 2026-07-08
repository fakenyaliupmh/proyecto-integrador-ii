extends Node
class_name CompleteWordGame

const UNDERSCORE = preload("res://src/underscore.tscn")
const MAX_WORD_POOL_SIZE = 18

var current_word: String = ""
var screen_size: Vector2 = Vector2.ZERO

var answer_slot: Array[String] = []
var slot_nodes: Array[Label] = []
var used_buttons: Array[Button] = []

func setup(word: String, new_screen_size: Vector2) -> void:
	self.current_word = word
	self.screen_size = new_screen_size
	generate_words_pool(current_word)
	gen_text_underscore(current_word)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("delete"):
		remove_last_letter()

	if Input.is_action_just_pressed("enter"):
		check_answer()

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
	var start_x = screen_size.x * 1.20
	var y = screen_size.y * 0.46
	var spacing = 80

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
		screen_size.x * 1.20 + (index % 6) * 100,
		screen_size.y * 0.65 + int(index / 6) * 80
	)

	button.add_theme_font_size_override("font_size", 32)
	add_child(button)

	button.pressed.connect(func():
		_on_letter_pressed(button)
	)

func _on_letter_pressed(button: Button) -> void:
	var letter := button.text

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

func check_answer() -> void:
	var player_word = ""

	for letter in answer_slot:
		player_word += letter

	if player_word == current_word:
		print("Correcto")
	else:
		print("Incorrecto")
