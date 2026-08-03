extends Node2D

const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const SCREEN_SIZE = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
const SCENES = {
	"home": preload("res://scenes/home_screen.tscn"),
	"pick_character": preload("res://scenes/pick_character.tscn"),
	"end": preload("res://scenes/end_scene.tscn")
	}

var current_game: CompleteWordGame = null
var selected_character: Texture2D = null
var title_sprite: AnimatedSprite2D = null
var pause = false

var instructions = preload("res://voices/instructions/instructions.mp3")
var can_you_write = preload("res://voices/main/can_you_write.mp3")

var max_levels = 5
var level_counter = 0

var backgrounds: Dictionary = {
	"dram": preload("res://assets/wallpaper/dream.png"),
	"sunset": preload("res://assets/wallpaper/sunset.png"),
	"rest": preload("res://assets/wallpaper/rest.png"),
	"day": preload("res://assets/wallpaper/day.png"),
	"night": preload("res://assets/wallpaper/night.png"),
}

var music: Dictionary = {
	"main_menu": preload("res://sfx/main_menu.mp3"),
	"game_music": preload("res://sfx/game_music.mp3"),
}

var sfx: Dictionary = {
	"select_character": preload("res://sfx/select_character.mp3"),
	"correct01": preload("res://sfx/correct01.mp3"),
	"correct02": preload("res://sfx/correct02.mp3"),
	"try_again": preload("res://sfx/try_again.mp3"),
	"end_game_button": preload("res://sfx/end_game.mp3"),
}

var try_again = [
	preload("res://voices/try_again/try01.mp3"),
	preload("res://voices/try_again/try02.mp3"),
	preload("res://voices/try_again/try03.mp3"),
	preload("res://voices/try_again/try04.mp3"),
	preload("res://voices/try_again/try05.mp3"),
]

var correct = [
	preload("res://voices/correct/asi_se_hace.mp3"),
	preload("res://voices/correct/good_job.mp3"),
	preload("res://voices/correct/thats_it.mp3"),
]

var congratulations = preload("res://voices/congratulations/congrats.mp3")

# This is just made for test
var wordss = [
	{
		"word": "avión",
		"sprite": preload("res://assets/words/avion.png")
	},
]

var words = [
	{
		"word": "casa",
		"sprite": preload("res://assets/words/casa.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/casa.mp3"),
	},
	{
		"word": "perro",
		"sprite": preload("res://assets/words/perro.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/perro.mp3"),
	},
	{
		"word": "sol",
		"sprite": preload("res://assets/words/sol.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/sol.mp3"),
	},
	{
		"word": "luna",
		"sprite": preload("res://assets/words/luna.png"),
		"bg": backgrounds["night"],
		"sfx": preload("res://voices/words/luna.mp3"),
	},
	{
		"word": "estrella",
		"sprite": preload("res://assets/words/estrella.png"),
		"bg": backgrounds["night"],
		"sfx": preload("res://voices/words/estrella.mp3"),
	},
	{
		"word": "nube",
		"sprite": preload("res://assets/words/nube.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/nube.mp3"),
	},
	{
		"word": "árbol",
		"sprite": preload("res://assets/words/arbol.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/arbol.mp3"),
	},
	{
		"word": "flor",
		"sprite": preload("res://assets/words/flor.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/flor.mp3"),
	},
	#{
	#	"word": "gato",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "pez",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "pajaro",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "mariposa",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "conejo",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "manzana",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "platano",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	{
		"word": "helado",
		"sprite": preload("res://assets/words/helado.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/helado.mp3"),
	},
	{
		"word": "pastel",
		"sprite": preload("res://assets/words/pastel.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/pastel.mp3"),
	},
	{
		"word": "pelota",
		"sprite": preload("res://assets/words/pelota.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/pelota.mp3"),
	},
	{
		"word": "cometa",
		"sprite": preload("res://assets/words/cometa.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/cometa.mp3"),
	},
	{
		"word": "carro",
		"sprite": preload("res://assets/words/carro.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/carro.mp3"),
	},
	{
		"word": "bicicleta",
		"sprite": preload("res://assets/words/bicicleta.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/bicicleta.mp3"),
	},
	{
		"word": "barco",
		"sprite": preload("res://assets/words/barco.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/barco.mp3"),
	},
	{
		"word": "avión",
		"sprite": preload("res://assets/words/avion.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/avion.mp3"),
	},
	{
		"word": "corazón",
		"sprite": preload("res://assets/words/corazon.png"),
		"bg": backgrounds["day"],
		"sfx": preload("res://voices/words/corazon.mp3"),
	},
	#{
	#	"word": "corona",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "robot",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "dinosaurio",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "castillo",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
	#{
	#	"word": "globo",
	#	"sprite": preload("res://assets/words/arbol.png"),
	#},
]

func _ready() -> void:
	play_music(music["main_menu"])
	
	self.pause = true
	set_title()
	await play_title_animation()
	self.pause = false
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if pause:
		return
	if Input.is_action_just_pressed("click"):
		$playButton/CollisionShape2D.disabled = true
		
		play_sfx(sfx["select_character"])
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(title_sprite, "modulate:a", 0.0, 0.6)
		
		$playButton/ButtonAnimation.play("play")
		$esceneAnimations.play("start_play")

func _on_escene_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_play":
		show_character_selection()

func play_music(stream) -> void:
	$MusicPlayer.stop()
	$MusicPlayer.stream = stream
	$MusicPlayer.volume_db = -12
	$MusicPlayer.play()

func play_music_lower(stream) -> void:
	$MusicPlayer.stop()
	$MusicPlayer.stream = stream
	$MusicPlayer.volume_db = -24
	$MusicPlayer.play()

func stop_music() -> void:
	$MusicPlayer.stop()

func play_sfx(stream) -> void:
	$SFXPlayer.stop()
	$SFXPlayer.stream = stream
	$SFXPlayer.volume_db = -12
	$SFXPlayer.play()

func play_voice(stream) -> void:
	$VoicePlayer.stop()
	$VoicePlayer.stream = stream
	$VoicePlayer.play()

func play_voice_and_wait(stream) -> void:
	$VoicePlayer.stop()
	$VoicePlayer.stream = stream
	$VoicePlayer.play()
	await $VoicePlayer.finished

func set_title() -> void:
	var title: Texture2D = preload(
		"res://assets/sprites/title_words.png"
	)

	title_sprite = AnimatedSprite2D.new()
	title_sprite.name = "TitleSprite"
	title_sprite.position = Vector2(
		SCREEN_WIDTH * 0.5,
		SCREEN_HEIGHT * 0.20
	)
	title_sprite.z_index = 2

	var frames = SpriteFrames.new()
	frames.remove_animation("default")

	frames.add_animation("intro")
	frames.set_animation_loop("intro", false)
	frames.set_animation_speed("intro", 13.0 / 2.0)

	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 2.0)

	var frame_width = title.get_width() / 5.0
	var frame_height = title.get_height() / 3.0

	for row in range(3):
		for column in range(5):
			var frame_index = row * 5 + column

			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = title
			atlas_texture.region = Rect2(
				column * frame_width,
				row * frame_height,
				frame_width,
				frame_height
			)

			if frame_index < 13:
				frames.add_frame("intro", atlas_texture)
			else:
				frames.add_frame("idle", atlas_texture)

	title_sprite.sprite_frames = frames

	add_child(title_sprite)

func play_title_animation() -> void:
	title_sprite.play("intro")
	await title_sprite.animation_finished

	title_sprite.play("idle")
	
func show_character_selection() -> void:
	var selection_menu = SCENES["pick_character"].instantiate()
	selection_menu.get_node("AnimationPlayer").play("fade_in")
	add_child(selection_menu)
	selection_menu.character_chosen.connect(_on_character_chosen)

func _on_character_chosen(chosen_texture: Texture2D) -> void:
	selected_character = chosen_texture
	var menu = get_node("CharacterSelection")
	play_music_lower(music["game_music"])
	if menu:
		menu.queue_free()
	next_round()

func _on_word_completed() -> void:
	if not is_instance_valid(current_game):
		return

	current_game.stop = true
	current_game.set_controls_enabled(false)

	var tween = create_tween()
	tween.tween_property(
		current_game,
		"modulate:a",
		0.0,
		1.0
	)

	await tween.finished
	level_counter += 1
	next_round()

func select_random_word() -> Dictionary:
	if words.is_empty() or level_counter == max_levels:
		return {}

	return words.pop_at(randi_range(0, words.size() - 1))

func next_round() -> void:
	if is_instance_valid(current_game):
		current_game.queue_free()

	current_game = null

	generate_new_scene()

func generate_new_scene() -> void:
	if words.is_empty() or level_counter == max_levels:
		play_final_scene()
		return

	var word: Dictionary = select_random_word()

	current_game = CompleteWordGame.new()
	current_game.home = self

	current_game.setup(
				word,
				SCREEN_SIZE,
				selected_character,
				)

	current_game.word_completed.connect(_on_word_completed)
	add_child(current_game)

	current_game.begin_round()

func play_final_scene() -> void:
	var new_scene = SCENES["end"].instantiate()
	new_scene.home = self

	new_scene.setup(
		SCREEN_SIZE,
		selected_character,
		backgrounds["night"]
	)
	
	add_child(new_scene)
