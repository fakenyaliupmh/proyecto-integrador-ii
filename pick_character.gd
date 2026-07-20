extends Control

signal character_chosen(character_texture)

var dragon_tex = preload("res://assets/sprites/dragon.png")
var ajolote_tex = preload("res://assets/sprites/ajolote.png")

func _on_dragon_button_pressed() -> void:
	character_chosen.emit(dragon_tex)
	
func _on_ajolote_button_pressed() -> void:
	character_chosen.emit(ajolote_tex)
