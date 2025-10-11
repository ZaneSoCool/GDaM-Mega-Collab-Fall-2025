extends Button


func _on_Button_pressed():
	for slot in $HBoxContainer.get_children():
		slot.spin()
