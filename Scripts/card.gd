extends Control
class_name Card

#Made by Kian edited by Zane

@onready var sprite: Sprite2D = $Sprite2D

var card_id : int = 1 #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suite : int = 1 #1, 2, 3, 4
var faceUp : bool = true

const back_texture = preload("res://Assets/Textures/cards/backOfCard.png")

const bone_text = preload("res://Assets/Textures/cards/bone.png")

const teeth_text = preload("res://Assets/Textures/cards/teeth.png")

const eye_text = preload("res://Assets/Textures/cards/eye.png")

const blood_text = preload("res://Assets/Textures/cards/blood.png")

func _ready() -> void:
	if faceUp:
		sprite.hframes = 13
		setup_card_texture(card_id, card_suite)
	else:
		sprite.hframes = 1
		sprite.texture = back_texture
		
	sprite.rotation_degrees = randf_range(-7,7)
	sprite.position.x += randf_range(-2,2)
	sprite.position.y += randf_range(-8, 8)
		
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
	
	
