extends Node2D
var screen_size: Vector2 = Vector2.ZERO
var current_character: Texture2D = null
var background: Texture2D = null

var home = null

func _ready() -> void:
	create_text()
	create_restart_button()
	home.play_voice(home.congratulations)

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home_screen.tscn")

func create_text() -> void:
	var label = Label.new()

	label.text = "¡Felicidades!\n\nHas terminado el juego.\n\n¡Sigue aprendiendo todos los días!"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(0,120)
	label.size = Vector2(screen_size.x,300)
	label.add_theme_font_size_override("font_size",60)

	add_child(label)

func create_restart_button() -> void:
	var button = Button.new()

	button.text = "  Volver al inicio  "
	button.size = Vector2(280, 80)
	button.position = Vector2(
		screen_size.x * 0.85,
		screen_size.y * 0.85
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

	button.pressed.connect(_on_restart_button_pressed)

func setup(new_screen_size: Vector2, character: Texture2D, bg: Texture2D = null) -> void:
	self.screen_size = new_screen_size
	self.current_character = character
	self.background = bg
	
	set_character()
	set_background()

func set_character() -> void:
	var character_sprite_node = AnimatedSprite2D.new()
	
	character_sprite_node.name = "CharacterSprite"
	character_sprite_node.position = Vector2(
		screen_size.x * 0.50,
		screen_size.y * 0.80
	)
	character_sprite_node.scale = Vector2(0.3, 0.3)
	character_sprite_node.z_index = 2

	var frames = SpriteFrames.new()
	frames.remove_animation("default")
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 3.0)

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

func set_background() -> void:
	if background == null:
		return
	
	var bg_node = Sprite2D.new()
	bg_node.name = "Background"
	bg_node.texture = background
	bg_node.position = screen_size * 0.5
	bg_node.z_index = 0

	var texture_size = background.get_size()

	if texture_size.x > 0.0 and texture_size.y > 0.0:
		var scale_factor = max(
			screen_size.x / texture_size.x,
			screen_size.y / texture_size.y
		)

		bg_node.scale = Vector2.ONE * scale_factor
		bg_node.modulate = bg_node.modulate.darkened(0.65)

	add_child(bg_node)
