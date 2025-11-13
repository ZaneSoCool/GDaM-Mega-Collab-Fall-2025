extends Control

@onready var foldable_container: FoldableContainer = $FoldableContainer
@onready var confirmation_dialog: ConfirmationDialog = $FoldableContainer/VBoxContainer/Button/ConfirmationDialog

#made by Zane Pederson

func _ready() -> void:
	foldable_container.folded = true
	confirmation_dialog.visible = false
	
func _on_button_pressed() -> void:
	confirmation_dialog.visible = true

func _on_confirmation_dialog_canceled() -> void:
	foldable_container.folded = true
	confirmation_dialog.visible = false
	
func _on_confirmation_dialog_confirmed() -> void:
	SceneTransition.change_scene_to("res://Scenes/Menu.tscn")
