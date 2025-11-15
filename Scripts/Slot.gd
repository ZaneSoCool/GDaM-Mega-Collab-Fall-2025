extends Control
class_name Slot

@onready var slotGraphic = $TextureRect
var id : int = 0 #1 = tooth, 2 = bone, 3 = eye, 4 = blood, 5 = joker

func spin(symbols : Array[Texture]):
	var random_index = randi_range(0, symbols.size() - 1)
	slotGraphic.texture = symbols[random_index]
