extends Control

@onready var foldable_container: FoldableContainer = $FoldableContainer
@onready var confirmation_dialog: ConfirmationDialog = $FoldableContainer/VBoxContainer/Button/ConfirmationDialog
@onready var fullscreen_button: CheckButton = $FoldableContainer/VBoxContainer/FullscreenButton

#made by Zane Pederson

func _ready() -> void:
	foldable_container.folded = true
	confirmation_dialog.visible = false
	
	if DisplayServer.window_get_mode() == 4:
		fullscreen_button.button_pressed = true
	else:
		fullscreen_button.button_pressed = false
	
func _on_button_pressed() -> void:
	confirmation_dialog.visible = true

func _on_confirmation_dialog_canceled() -> void:
	foldable_container.folded = true
	confirmation_dialog.visible = false
	
func _on_confirmation_dialog_confirmed() -> void:
	SceneTransition.change_scene_to("res://Scenes/Menu.tscn")

func _on_check_button_pressed() -> void:
	if fullscreen_button.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
