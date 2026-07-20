extends Node2D

const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const SCREEN_SIZE = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)

var current_game: CompleteWordGame = null

var characters: Array = [
	preload("res://assets/characters/dragon.png"),
	preload("res://assets/characters/ajolote.png")
]

var background_stack: Array = [
	preload("res://assets/wallpaper/fondo (20260706031742).png"),
	preload("res://assets/wallpaper/Proyecto (20260706032907).png"),
	preload("res://assets/wallpaper/Proyecto (20260706032833).png"),
]

var words = [
	{
		"word": "casa",
		"sprite": preload("res://assets/words/casa.png")
	},
	{
		"word": "perro",
		"sprite": preload("res://assets/words/perro.png")
	},
	{
		"word": "sol",
		"sprite": preload("res://assets/words/sol.png")
	},
	{
		"word": "luna",
		"sprite": preload("res://assets/words/luna.png")
	},
	{
		"word": "estrella",
		"sprite": preload("res://assets/words/estrella.png")
	},
	{
		"word": "nube",
		"sprite": preload("res://assets/words/nube.png")
	},
	{
		"word": "arbol",
		"sprite": preload("res://assets/words/arbol.png")
	},
	{
		"word": "flor",
		"sprite": preload("res://assets/words/flor.png")
	},
	#{
	#	"word": "gato",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "pez",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "pajaro",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "mariposa",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "conejo",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "manzana",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "platano",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "helado",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "pastel",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "pelota",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "cometa",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	{
		"word": "carro",
		"sprite": preload("res://assets/words/carro.png")
	},
	{
		"word": "bicicleta",
		"sprite": preload("res://assets/words/bicicleta.png")
	},
	{
		"word": "barco",
		"sprite": preload("res://assets/words/barco.png")
	},
	{
		"word": "avion",
		"sprite": preload("res://assets/words/avion.png")
	},
	{
		"word": "corazon",
		"sprite": preload("res://assets/words/corazon.png")
	},
	#{
	#	"word": "corona",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "robot",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "dinosaurio",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "castillo",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
	#{
	#	"word": "globo",
	#	"sprite": preload("res://assets/words/arbol.png")
	#},
]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		$playButton/CollisionShape2D.disabled = true
		$playButton/ButtonAnimation.play("play")
		$esceneAnimations.play("start_play")

func _on_escene_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_play":
		next_round()

func _on_word_completed() -> void:
	if not is_instance_valid(current_game):
		return

	current_game.stop = true

	var tween = create_tween()
	tween.tween_property(
		current_game,
		"modulate:a",
		0.0,
		1.0
	)

	await tween.finished
	next_round()

func select_random_word() -> Dictionary:
	var my_dict = words.pick_random()
	return my_dict

func next_round() -> void:
	if is_instance_valid(current_game):
		current_game.queue_free()

	current_game = null

	generate_new_scene()

func generate_new_scene() -> void:
	var word: Dictionary = select_random_word()
	var character: Texture2D = characters.pick_random()
	var background: Texture2D = background_stack.pick_random()

	current_game = CompleteWordGame.new()
	current_game.word_completed.connect(_on_word_completed)
	add_child(current_game)

	current_game.setup(
		word,
		SCREEN_SIZE,
		character,
		background
	)

	current_game.stop = false
