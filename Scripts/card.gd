extends Control
class_name Card

#Initialized by Kian edited by Zane

@onready var sprite: Sprite2D = $Sprite2D

@export var dealer_color: Color
@export var hover_color: Color

var card_id : int = 1 #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suite : int = 1 #1, 2, 3, 4
var faceUp : bool = true
var forPlayer : bool

var isHovering : bool = false
var isHeld : bool = false
var prevMousePos : Vector2

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
		
	if !forPlayer:
		sprite.self_modulate = dealer_color
	
	randomizePlacement(true)
		
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

func _on_mouse_entered() -> void:
	isHovering = true
	if forPlayer:
		sprite.self_modulate = hover_color
	else:
		sprite.self_modulate = hover_color * dealer_color

func _on_mouse_exited() -> void:
	isHovering = false
	if !isHeld:
		if forPlayer:
			sprite.self_modulate = Color.WHITE
		else:
			sprite.self_modulate = dealer_color
	
func _input(event: InputEvent) -> void:
	if isHovering and Input.is_action_just_pressed("click"):
		isHeld = true
		prevMousePos = get_global_mouse_position()
		
	elif isHeld and Input.is_action_just_released("click"):
		randomizePlacement(true)
		isHeld = false
		
func _process(delta: float) -> void:
	if isHeld:
		global_position += (get_global_mouse_position() - prevMousePos) #Vector2(40, 51)
		prevMousePos = get_global_mouse_position()

func randomizePlacement(randomizePosition : bool):
	sprite.rotation_degrees = randf_range(-7,7)
	
	if randomizePosition:
		sprite.position.x += randf_range(-2,2)
		sprite.position.y += randf_range(-8, 8)
	
