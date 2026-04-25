extends Control
class_name Card

#Initialized by Kian edited by Zane

@onready var sprite: Sprite2D = $Sprite2D

@export var hover_color: Color

var card_id : int = 1 #1,2.. 11 (Jack), 12 (Queen), 13 (King)
var card_suit : int = 1 #1, 2, 3, 4 (bone, teeth, eye, blood)
var faceUp : bool = true

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
		setup_card_texture(card_id, card_suit)
	else:
		sprite.hframes = 1
		sprite.texture = back_texture
	
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

	sprite.hframes = 13
	sprite.frame = value - 1

func _on_mouse_entered() -> void:
	isHovering = true
	sprite.self_modulate = hover_color

func _on_mouse_exited() -> void:
	isHovering = false
	if !isHeld:
		sprite.self_modulate = Color.WHITE
	
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
		
		#clamps card position so it can't leave play area
		global_position.x = clamp(global_position.x, 180, 972)
		global_position.y = clamp(global_position.y, 110, 410)
		
		prevMousePos = get_global_mouse_position()
		
func randomizePlacement(randomizePosition : bool):
	sprite.rotation_degrees = randf_range(-7,7)
	
	if randomizePosition:
		sprite.position.x += randf_range(-2,2)
		sprite.position.y += randf_range(-8, 8)
	
