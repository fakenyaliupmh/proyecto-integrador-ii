extends Node2D

const underscore = preload("res://src/underscore.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#Diccionario de palabras
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
	
#Función prara seleccionar la palabra
func select_random_word() -> String:
	var claves = words.keys()
	var clave_random = claves[randi()% claves.size()]
	print(words[clave_random])
	return words[clave_random]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		$playButton/CollisionShape2D.disabled = true
		$esceneAnimations.play("start_play")

func _on_escene_animations_animation_finished(anim_name: StringName) -> void:
	$Camera2D.position.x = 2880
	$coAnimations.play("end_animation")
	var my_word = select_random_word()
	generate_words_pool(my_word)
	gen_text_underscore(my_word)
	
func generate_words_pool(word: String) -> void:
	var word_pool = []
	for l in word:
		word_pool.append(l)
	
	var alphabet := "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"
	while word_pool.size() < 12:
		var random_letter = alphabet[randi() % alphabet.length()]
		if not word_pool.has(random_letter):
			word_pool.append(random_letter)

	word_pool.shuffle()

	print("Pool de letras: ", word_pool)

	for i in word_pool.size():
		create_letter_label(word_pool[i], i)

func gen_text_underscore(word: String) -> void:
	var start_x = 2304
	var y = 500
	var spacing = 80

	for i in word.length():
		var my_asset = underscore.instantiate()
		my_asset.position = Vector2(start_x + i * spacing, y)
		add_child(my_asset)
		
func create_letter_label(letter: String, index: int) -> void:
	var label = Label.new()
	label.text = letter
	label.position = Vector2(2304 + (index % 6) * 100, 700 + int(index / 6) * 80)
	label.add_theme_font_size_override("font_size", 48)
	add_child(label)
