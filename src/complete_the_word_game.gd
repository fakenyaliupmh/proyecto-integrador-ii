extends Node2D
class_name CompleteWordGame
signal word_completed

const UNDERSCORE = preload("res://scenes/underscore.tscn")
const MAX_WORD_POOL_SIZE = 18
const ROUND_INPUT_DELAY = 0.1

const CORRECT_COLOR = Color("#57C785")
const TRY_AGAIN_COLOR = Color("#F2B84B")
const NORMAL_COLOR = Color.WHITE

var screen_size: Vector2 = Vector2.ZERO
var current_word: String = ""
var word_sprite: Texture2D = null
var current_character: Texture2D = null
var current_bg: Texture2D = null
var current_audio = null

var home: Node2D = null

var check_button: Button = null
var letter_buttons: Array[Button] = []
var answer_slot: Array[String] = []
var slot_nodes: Array[Label] = []
var used_buttons: Array[Button] = []

var stop: bool = true

var attemps = 0

func _input(event) -> void:
	if stop:
		return

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

func setup(
		word: Dictionary,
		new_screen_size: Vector2,
		character: Texture2D = null,
	) -> void:

	self.screen_size = new_screen_size
	self.current_character = character
	self.current_bg = word["bg"]

	self.current_word = word["word"].to_upper()
	self.word_sprite = word["sprite"]
	self.current_audio = word["sfx"]

	modulate.a = 0.0 # Magic number

	set_background()
	set_word_sprite()
	set_character()
	
	generate_words_pool(current_word)
	gen_text_underscore(current_word)
	create_check_button()

func begin_round() -> void:
	stop = true
	set_controls_enabled(false)

	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await fade_tween.finished

	await get_tree().create_timer(ROUND_INPUT_DELAY).timeout

	if not is_inside_tree():
		return

	await home.play_voice_and_wait(home.can_you_write)
	await home.play_voice(current_audio)

	stop = false
	set_controls_enabled(true)

func create_check_button() -> void:
	var button = Button.new()
	check_button = button
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

func set_background() -> void:
	if current_bg == null:
		return
	
	var bg_node = Sprite2D.new()
	bg_node.name = "Background"
	bg_node.texture = current_bg
	bg_node.position = screen_size * 0.5
	bg_node.z_index = 0

	var texture_size = current_bg.get_size()

	if texture_size.x > 0.0 and texture_size.y > 0.0:
		var scale_factor = max(
			screen_size.x / texture_size.x,
			screen_size.y / texture_size.y
		)

		bg_node.scale = Vector2.ONE * scale_factor
		bg_node.modulate = bg_node.modulate.darkened(0.65)

	add_child(bg_node)

func set_word_sprite() -> void:
	if word_sprite == null:
		return

	var word_sprite_node = AnimatedSprite2D.new()
	
	word_sprite_node.name = "WordSprite"
	word_sprite_node.position = Vector2(
		screen_size.x * 0.25,
		screen_size.y * 0.30
	)
	word_sprite_node.scale = Vector2(0.35, 0.35)
	word_sprite_node.z_index = 1

	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 6.0)

	var frame_width = word_sprite.get_width() / 3
	var frame_height = word_sprite.get_height() / 2

	for row in range(2):
		for column in range(3):
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = word_sprite
			atlas_texture.region = Rect2(
				column * frame_width,
				row * frame_height,
				frame_width,
				frame_height
			)

			frames.add_frame("idle", atlas_texture)

	word_sprite_node.sprite_frames = frames
	add_child(word_sprite_node)
	word_sprite_node.play("idle")

func set_character() -> void:
	if current_character == null:
		return

	var character_sprite_node = AnimatedSprite2D.new()
	
	character_sprite_node.name = "CharacterSprite"
	character_sprite_node.position = Vector2(
		screen_size.x * 0.15,
		screen_size.y * 0.80
	)
	character_sprite_node.scale = Vector2(0.3, 0.3)
	character_sprite_node.z_index = 2

	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 2.0)

	var columns = 4
	var frame_width = current_character.get_width() / columns
	var frame_height = current_character.get_height()

	for i in range(4):
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = current_character
		atlas_texture.region = Rect2(
			i * frame_width,
			0,
			frame_width,
			frame_height
		)

		frames.add_frame("idle", atlas_texture)

	character_sprite_node.sprite_frames = frames
	add_child(character_sprite_node)
	character_sprite_node.play("idle")

func create_letter_button(letter: String, index: int) -> void:
	var button = Button.new()
	letter_buttons.append(button)
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
	if stop:
		return
	
	var letter = button.text

	for i in range(answer_slot.size()):
		if answer_slot[i] == "":
			answer_slot[i] = letter
			slot_nodes[i].text = letter
			used_buttons.append(button)
			button.disabled = true
			break

func set_controls_enabled(enabled: bool) -> void:
	if is_instance_valid(check_button):
		check_button.disabled = not enabled

	for button in letter_buttons:
		if not is_instance_valid(button):
			continue

		button.disabled = not enabled or used_buttons.has(button)

func remove_last_letter() -> void:
	if stop:
		return

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
	if stop:
		return false

	self.stop = true
	set_controls_enabled(false)
	
	var player_word = ""

	for letter in answer_slot:
		player_word += letter

	if player_word == current_word:
		await correct_animation()
		word_completed.emit()
		return true

	attemps += 1 # Magic number
	await incorrect_animation()
	
	if attemps >= 5: # Magic number
		complete_word()
		return true
	self.stop = false
	set_controls_enabled(true)
	return false

func reveal_random_letter() -> void:
	pass

func complete_word() -> void:
	self.stop = true
	set_controls_enabled(false)
	
	for i in range(current_word.length()):
		answer_slot[i] = current_word[i]
		slot_nodes[i].text = current_word[i]
	
	await correct_animation()
	word_completed.emit()
	
func incorrect_animation() -> void:
	home.play_sfx(home.sfx["try_again"])
	home.play_voice(home.try_again.pick_random())
	var original_positions: Array[Vector2] = []

	for label in slot_nodes:
		original_positions.append(label.position)
		label.add_theme_color_override("font_color", TRY_AGAIN_COLOR)

	var tween = create_tween()

	for i in range(slot_nodes.size()):
		var label = slot_nodes[i]
		var original_position := original_positions[i]

		tween.parallel().tween_property(
			label,
			"position:x",
			original_position.x + 8.0,
			0.10
		)

	await tween.finished

	var return_tween = create_tween()

	for i in range(slot_nodes.size()):
		return_tween.parallel().tween_property(
			slot_nodes[i],
			"position",
			original_positions[i],
			0.18
		)

	await return_tween.finished
	await get_tree().create_timer(0.25).timeout

	for label in slot_nodes:
		label.add_theme_color_override("font_color", NORMAL_COLOR)

func correct_animation() -> void:
	if (home.max_levels - home.level_counter) == 1:
		home.play_sfx(home.sfx["correct02"])
	else:
		home.play_sfx(home.sfx["correct01"])

	home.play_voice(home.correct.pick_random())

	for label in slot_nodes:
		if not is_instance_valid(label):
			continue

		label.pivot_offset = label.size * 0.5
		label.add_theme_color_override("font_color", CORRECT_COLOR)

		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(label, "scale", Vector2(1.25, 1.25), 0.15)
		tween.tween_property(label, "scale", Vector2.ONE, 0.20)

		await get_tree().create_timer(0.06).timeout

	await get_tree().create_timer(0.35).timeout
