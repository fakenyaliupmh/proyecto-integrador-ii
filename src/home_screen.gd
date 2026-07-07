extends Node2D

const underscore = preload("res://src/underscore.tscn")
const max_word_pool_size = 12
const screen_width = 1920
const screen_height = 1080

var current_word = ""
var answer_slot = []
var slot_nodes = []
var used_buttons = []

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
	if Input.is_action_just_pressed("delete"): 
		remove_last_letter()
	if Input.is_action_just_pressed("enter"):
		check_answer()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		$playButton/CollisionShape2D.disabled = true
		$playButton/ButtonAnimation.play("play")
		$esceneAnimations.play("start_play")

func _on_escene_animations_animation_finished(anim_name: StringName) -> void:
	$Camera2D.position.x = 2880
	$coAnimations.play("end_animation")
	current_word = select_random_word().to_upper()
	generate_words_pool(current_word)
	gen_text_underscore(current_word)
	
func generate_words_pool(word: String) -> void:
	var word_pool = []
	for l in word:
		word_pool.append(l)
	
	var alphabet := "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"
	while word_pool.size() < max_word_pool_size:
		var random_letter = alphabet[randi() % alphabet.length()]
		if not word_pool.has(random_letter):
			word_pool.append(random_letter)
			
	for i in range(word_pool.size()):
		word_pool[i] = word_pool[i].to_upper()

	word_pool.shuffle()

	print("Pool de letras: ", word_pool)

	for i in word_pool.size():
		create_letter_button(word_pool[i], i)

func gen_text_underscore(word: String) -> void:
	var start_x = 2304
	var y = 500
	var spacing = 80

	answer_slot.clear()
	slot_nodes.clear()

	for i in word.length():
		answer_slot.append("")

		var my_asset = underscore.instantiate()
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
	button.position = Vector2(2304 + (index % 6) * 100, 700 + int(index / 6) * 80)
	button.add_theme_font_size_override("font_size", 32)
	add_child(button)

	button.pressed.connect(func():
		_on_letter_pressed(button)
	)
	
func _on_letter_pressed(button: Button) -> void:
	var letter = button.text

	for i in answer_slot.size():
		if answer_slot[i] == "":
			answer_slot[i] = letter
			slot_nodes[i].text = letter
			used_buttons.append(button)
			button.disabled = true
			break
			
func remove_last_letter() -> void:
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

	if player_word == current_word.to_upper():
		print("Correcto")
	else:
		print("Incorrecto")
