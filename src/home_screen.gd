extends Node2D

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_random_word()
	
#Función prara seleccionar la palabra
func select_random_word() -> void:
	var claves = words.keys()
	var clave_random = claves[randi()% claves.size()]
	print(words[clave_random])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		print("It works")
		select_random_word()
