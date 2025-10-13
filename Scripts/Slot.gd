extends Control
class_name Slot

@onready var SlotGraphic = $TextureRect

func spin(symbols : Array[Texture]):
	var random_index = randi() % symbols.size()
	SlotGraphic.texture = symbols[random_index]
