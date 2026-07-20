extends Node2D
var screen_size: Vector2 = Vector2.ZERO
var current_character: Texture2D = null
var background: Texture2D = null

func setup(new_screen_size: Vector2, character: Texture2D, bg: Texture2D) -> void:
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
		screen_size.y * 0.50
	)
	character_sprite_node.scale = Vector2(0.5, 0.5)
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
	pass
