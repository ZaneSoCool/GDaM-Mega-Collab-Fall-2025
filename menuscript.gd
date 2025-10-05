extends Control

func _on_button_pressed() -> void:
	#Make sure to add starting scene from here
	get_tree().change_scene_to_file("res://(INSERT_START_SCENE_HERE).tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
