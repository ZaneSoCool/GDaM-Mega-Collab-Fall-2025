extends Control

#Made by Henry

func _on_button_pressed() -> void:
	SoundController.buttonPressed()
	SceneTransition.change_scene_to("res://Scenes/BlackJack.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	SceneTransition.change_scene_to("res://Scenes/credits.tscn")
