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
	SoundController.buttonPressed()
	confirmation_dialog.visible = true

func _on_confirmation_dialog_canceled() -> void:
	SoundController.buttonPressed()
	foldable_container.folded = true
	confirmation_dialog.visible = false
	
func _on_confirmation_dialog_confirmed() -> void:
	SoundController.buttonPressed()
	SceneTransition.change_scene_to("res://Scenes/Menu.tscn")

func _on_check_button_pressed() -> void:
	SoundController.buttonPressed()
	if fullscreen_button.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_foldable_container_folding_changed(is_folded: bool) -> void:
	SoundController.buttonPressed()
