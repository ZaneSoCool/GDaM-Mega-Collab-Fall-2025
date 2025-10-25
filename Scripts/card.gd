extends Control
class_name Card

#Made by Kian edited by Zane

@onready var card_texture: TextureRect = $Card_Texture
@onready var suite_texture: TextureRect = $Suite_Texture
@onready var back_texture: Texture = preload("res://icon.svg")
@onready var label: Label = $Label

var card_id : int = 1 #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suite : int = 1 #1, 2, 3, 4
var faceUp : bool = true

var bone_id_text_dict = {
	1 : "res://icon.svg",
	2 : "res://icon.svg",
	3 : "res://icon.svg",
	4 : "res://icon.svg",
	5 : "res://icon.svg",
	6 : "res://icon.svg",
	7 : "res://icon.svg",
	8 : "res://icon.svg",
	9 : "res://icon.svg",
	10 : "res://icon.svg",
	11 : "res://icon.svg",
	12 : "res://icon.svg",
	13 : "res://icon.svg"
}

var teeth_id_text_dict = {
	1 : "res://icon.svg",
	2 : "res://icon.svg",
	3 : "res://icon.svg",
	4 : "res://icon.svg",
	5 : "res://icon.svg",
	6 : "res://icon.svg",
	7 : "res://icon.svg",
	8 : "res://icon.svg",
	9 : "res://icon.svg",
	10 : "res://icon.svg",
	11 : "res://icon.svg",
	12 : "res://icon.svg",
	13 : "res://icon.svg"
}

var eye_id_text_dict = {
	1 : "res://icon.svg",
	2 : "res://icon.svg",
	3 : "res://icon.svg",
	4 : "res://icon.svg",
	5 : "res://icon.svg",
	6 : "res://icon.svg",
	7 : "res://icon.svg",
	8 : "res://icon.svg",
	9 : "res://icon.svg",
	10 : "res://icon.svg",
	11 : "res://icon.svg",
	12 : "res://icon.svg",
	13 : "res://icon.svg"
}

var blood_id_text_dict = {
	1 : "res://icon.svg",
	2 : "res://icon.svg",
	3 : "res://icon.svg",
	4 : "res://icon.svg",
	5 : "res://icon.svg",
	6 : "res://icon.svg",
	7 : "res://icon.svg",
	8 : "res://icon.svg",
	9 : "res://icon.svg",
	10 : "res://icon.svg",
	11 : "res://icon.svg",
	12 : "res://icon.svg",
	13 : "res://icon.svg"
}

func _ready() -> void:
	if faceUp:
		card_texture.texture = load(get_card_texture(card_id, card_suite))
		label.text = str(card_id) + " " + str(card_suite)
	else:
		card_texture.texture = back_texture
		
func get_card_texture(value : int, suit : int):
	if suit == 1:
		return bone_id_text_dict[value]
	elif suit == 2:
		return bone_id_text_dict[value]
	elif suit == 3:
		return bone_id_text_dict[value]
	elif suit == 4:
		return bone_id_text_dict[value]
	else:
		"Uh Oh"
	
	
