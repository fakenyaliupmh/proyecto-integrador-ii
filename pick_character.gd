extends Control
class_name PickCharacter

signal character_chosen(character_texture)

const DRAGON = preload("res://assets/characters/dragon.png")
const AJOLOTE = preload("res://assets/characters/ajolote.png")

func _on_dragon_button_pressed() -> void:
	character_chosen.emit(DRAGON)
	
func _on_ajolote_button_pressed() -> void:
	character_chosen.emit(AJOLOTE)
