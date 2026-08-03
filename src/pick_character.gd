extends Control
class_name PickCharacter
signal character_chosen(character_texture)

const DRAGON = preload("res://assets/characters/dragon.png")
const AJOLOTE = preload("res://assets/characters/ajolote.png")
const CAT = preload("res://assets/characters/cat.png")
const FOX = preload("res://assets/characters/fox.png")

var current_character: Texture2D = null

var is_paused = false

func play_selection_sound() -> void:
	var home = get_parent()
	home.stop_music()
	await home.play_sfx(home.sfx["select_character"])
	
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	
	character_chosen.emit(current_character)

func _on_dragon_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	current_character = DRAGON
	play_selection_sound()

func _on_ajolote_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	current_character = AJOLOTE
	play_selection_sound()

func _on_cat_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	current_character = CAT
	play_selection_sound()

func _on_fox_button_pressed() -> void:
	if is_paused:
		return
	is_paused = true
	current_character = FOX
	play_selection_sound()
