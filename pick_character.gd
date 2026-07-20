extends Control
class_name PickCharacter

signal character_chosen(character_texture)

const DRAGON = preload("res://assets/characters/dragon.png")
const AJOLOTE = preload("res://assets/characters/ajolote.png")
const CAT = preload("res://assets/characters/cat.png")
const FOX = preload("res://assets/characters/fox.png")

var current_character: Texture2D = null

var is_paused = false

func _on_selection_finished() -> void:
	character_chosen.emit(current_character)

func play_selection_sound() -> void:
	$AnimationPlayer.play("fade_out")
	$selection.playing = true

func _on_dragon_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	play_selection_sound()
	current_character = DRAGON

func _on_ajolote_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	play_selection_sound()
	current_character = AJOLOTE

func _on_cat_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	play_selection_sound()
	current_character = CAT

func _on_fox_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	play_selection_sound()
	current_character = FOX
