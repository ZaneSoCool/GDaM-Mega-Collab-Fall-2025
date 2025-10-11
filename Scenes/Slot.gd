extends Node2D

var SlotGraphic: Sprite2D


var symbols = [
	preload("res://assets/Cherry.jpg"),
	preload("res://assets/Lemon.jpg")
]

func spin():
	var random_index = randi() % symbols.size()
	SlotGraphic.texture = symbols[random_index]
