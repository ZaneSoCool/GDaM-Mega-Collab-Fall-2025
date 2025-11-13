extends Control

#Made by Henry

func _on_button_pressed() -> void:
	SoundController.buttonPressed()
	SceneTransition.change_scene_to("res://Scenes/levels/1_1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()
