extends Node2D

const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const SCREEN_SIZE = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)

var current_word: String = ""
var current_scene = preload("res://scenes/test_scene.tscn")
var current_scene_instance: Node = null
var current_game: CompleteWordGame = null

var words = {
	"word_1" : "Casa",
	"word_2" : "Perro",
	"word_3" : "Sol",
	"word_4" : "Luna",
	"word_5" : "Estrella",
	"word_6" : "Nube",
	"word_7" : "Arbol",
	"word_8" : "Flor",
	"word_9" : "Casa",
	"word_10" : "Gato",
	"word_11" : "Pez",
	"word_12" : "Pajaro",
	"word_13" : "Mariposa",
	"word_14" : "Conejo",
	"word_15" : "Manzana",
	"word_16" : "Platano",
	"word_17" : "Helado",
	"word_18" : "Pastel",
	"word_19" : "Pelota",
	"word_20" : "Cometa",
	"word_21" : "Coche",
	"word_22" : "Bicicleta",
	"word_23" : "Barco",
	"word_24" : "Avion",
	"word_25" : "Corazon",
	"word_26" : "Corona",
	"word_27" : "Robot",
	"word_28" : "Dinosaurio",
	"word_29" : "Castillo",
	"word_30" : "Globo"
}

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
	if current_scene_instance.has_node("AnimationPlayer"):
		current_scene_instance.get_node("AnimationPlayer").play("end_scene")

	var tween = create_tween()

	if current_game:
		tween.parallel().tween_property(current_game, "modulate:a", 0.0, 1.0)
		tween.parallel().tween_interval(1.5)

	await tween.finished

	next_round()


func select_random_word() -> String:
	var keys = words.keys()
	var random_keys = keys[randi()% keys.size()]
	print(words[random_keys])
	return words[random_keys]

func next_round():
	if current_game:
		current_game.queue_free()
		current_game = null

	if current_scene_instance:
		current_scene_instance.queue_free()
		current_scene_instance = null

	current_scene_instance = current_scene.instantiate()
	add_child(current_scene_instance)

	if current_scene_instance.has_node("AnimationPlayer"):
		current_scene_instance.get_node("AnimationPlayer").play("init_scene")

	var word = select_random_word().to_upper()

	current_game = CompleteWordGame.new()
	current_game.setup(word, SCREEN_SIZE)
	current_game.word_completed.connect(_on_word_completed)
	add_child(current_game)
