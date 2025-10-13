extends Button

@onready var slot_container: HBoxContainer = $"../SlotContainer"

@export var symbols : Array[Texture]

func _on_pressed() -> void:
	for child in slot_container.get_children():
		if child is Slot:
			child.spin(symbols)
