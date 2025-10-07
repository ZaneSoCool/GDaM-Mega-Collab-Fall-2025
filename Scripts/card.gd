extends Node2D

#Made by Kian edited by Zane

@onready var card_texture: TextureRect = $Card_Texture
@onready var suite_texture: TextureRect = $Suite_Texture
@onready var label: Label = $Label

var card_id : int #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suite : int #1, 2, 3, 4

var id_text_dict = {
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

var suite_text_dict = {
	1 : "res://icon.svg",
	2 : "res://icon.svg",
	3 : "res://icon.svg",
	4 : "res://icon.svg",
}

func _ready() -> void:
	if card_id == 0: #if card's id isnt setup it destoys itself
		queue_free()
		
	card_texture.texture = id_text_dict[card_id]
	suite_texture.texture = suite_text_dict[card_id]
	
	label.text = str(card_id)
