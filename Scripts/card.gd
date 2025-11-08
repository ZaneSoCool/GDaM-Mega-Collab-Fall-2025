extends Control
class_name Card

#Made by Kian edited by Zane

@onready var sprite: Sprite2D = $Sprite2D
@onready var suite_texture: TextureRect = $Suite_Texture
@onready var back_texture: Texture = preload("res://icon.svg")
@onready var label: Label = $Label

var card_id : int = 1 #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suite : int = 1 #1, 2, 3, 4
var faceUp : bool = true

const bone_text = preload("res://Assets/bone.png")

const teeth_text = preload("res://Assets/teeth.png")

const eye_text = preload("res://Assets/eye.png")

var blood_text = preload("res://Assets/blood.png")

func _ready() -> void:
	if faceUp:
		setup_card_texture(card_id, card_suite)
		label.text = str(card_id) + " " + str(card_suite)
	else:
		sprite.texture = back_texture
		
func setup_card_texture(value : int, suit : int):
	if suit == 1:
		sprite.texture = bone_text
	elif suit == 2:
		sprite.texture = teeth_text
	elif suit == 3:
		sprite.texture = eye_text
	elif suit == 4:
		sprite.texture = blood_text

	sprite.frame = value - 1
	
	
